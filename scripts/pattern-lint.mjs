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
import { walkFiles } from './lib/src-tree.mjs';

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
    // SLIN's "Redundant conversion for type I", which abaplint does not model
    // (measured on 2.120.24) and which therefore only ever surfaced from a
    // user's system: nine findings across 534/546/547/548/549/566/609 on
    // 2026-08-23, after a single one in 295 on 2026-08-17. An assignment
    // converts by itself, so CONV i( ) into a target that is already TYPE i
    // says nothing and reads as if a conversion were needed.
    //
    // Scoped to targets this file DECLARES as TYPE i - a DATA/CLASS-DATA line,
    // or a RETURNING/CHANGING/EXPORTING parameter. Anything whose type lives
    // in another class is left alone rather than guessed at: a false error
    // here costs more than a missed hint, and the CONV inside a string
    // template (|{ CONV i( ... ) WIDTH = 2 }|) is a real conversion that must
    // not be caught.
    id: 'redundant-conv-i',
    level: 'error',
    doc: 'CONV i( ) assigned to a target already TYPE i - the assignment converts by itself; SLIN reports "Redundant conversion for type I" (abap-check §3)',
    find(content) {
      const typed = new Set();
      const decl = /^\s*(?:CLASS-)?DATA\s+([a-z_][a-z_0-9]*)\s+TYPE\s+i\s*(?:VALUE\b[^.]*)?\./gim;
      let m;
      while ((m = decl.exec(content)) !== null) typed.add(m[1].toLowerCase());
      const param = /^\s*(?:VALUE\()?([a-z_][a-z_0-9]*)\)?\s+TYPE\s+i\s*$/gim;
      while ((m = param.exec(content)) !== null) typed.add(m[1].toLowerCase());
      if (typed.size === 0) return [];
      const out = [];
      // The CONV must be the WHOLE right-hand side: `<name> = CONV i( x ).`
      // That is the shape SLIN flags and the only one that is provably
      // pointless. A CONV inside a comparison (`COND #( WHEN CONV i( x ) < 14`)
      // or an arithmetic expression (`CONV i( x ) + 1`) is load-bearing or at
      // least arguable, and both were in the first draft of this rule as false
      // errors - apps 350 and 353, neither of which SLIN reported.
      const assign = /^[ \t]*([a-z_][a-z_0-9]*)[ \t]*=[ \t]*CONV[ \t]+i\([^()|]*\)[ \t]*\.[ \t]*$/gim;
      while ((m = assign.exec(content)) !== null) {
        if (!typed.has(m[1].toLowerCase())) continue;
        const line = lineOf(content, m.index);
        out.push({ line, text: content.split('\n')[line - 1].trim().slice(0, 90) });
      }
      return out;
    },
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
       * (AGENTS §3). Both shapes are a dispatcher, so the wire is not dead:
       *   CASE client->get_event( ).  WHEN `X`.        two or more events
       *   IF client->get_event( ) = `X`.               exactly one
       * The IF form is not a style choice — abaplint's `short_case` requires
       * it from a single-branch CASE (2026-08-16), so a one-event class can
       * no longer be written with WHEN at all. Ports still have to use
       * on_event, which the method-order rules below enforce for them.
       * `get( )-event` is the pre-2026-08-16 spelling of `get_event( )` and
       * is matched too: the corpus no longer contains it, but a hand-written
       * class or an older branch may. */
      const EVENT_READ = /get_event\(\s*\)|get\(\s*\)-event/;
      if (EVENT_READ.test(content) && /\bWHEN\b/.test(content)) return out;
      if (new RegExp('IF\\s+[^\\n]*(?:' + EVENT_READ.source + ')\\s*=').test(content)) return out;
      const m = content.match(/->_event\(/);
      out.push({ line: lineOf(content, m.index), text: '_event( ) wired but no on_event/check_on_event dispatcher and no CASE or IF on get_event( )' });
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
    // check_on_init( ) true implies check_on_navigated( ) true: every path to
    // an instance's first main( ) sets the flag (factory_first_start for a
    // fresh start AND a draft restore, factory_system_startup,
    // prepare_app_stack for nav_app_call and nav_app_leave). So an init branch
    // whose only statement is view_display( ) has an ELSEIF twin that does the
    // same thing, and the OR form says it in one line instead of four. 201
    // classes carried one of the two until 2026-08-28.
    id: 'redundant-init-display',
    level: 'error',
    doc: 'check_on_init( ) is the SEED branch, not a display branch — an init branch whose only statement is view_display( ), or an "init OR navigated" condition, decides nothing because init true implies navigated true (AGENTS §5)',
    find(content) {
      const out = [];
      const or = content.match(/^[ \t]*IF client->check_on_init\( \) OR client->check_on_navigated\( \)\./m);
      if (or) {
        out.push({ line: lineOf(content, or.index), text: 'IF check_on_init( ) OR check_on_navigated( ) — the OR is redundant' });
      }
      // BOTH arms have to be the bare view_display( ) — where the navigated
      // branch does something else (samples' app 488/012 call on_navigation( ),
      // app 024 handles an app return first) the fork DOES decide something and
      // the init branch stays. Blank lines between the branches are the samples
      // dispatcher style and must not hide the finding.
      const B = '(?:[ \\t]*\\n)*';
      const fork = content.match(new RegExp(
        '^([ \\t]*)IF client->check_on_init\\( \\)\\.\\n' + B +
        '\\1([ \\t]+)view_display\\( \\)\\.\\n' + B +
        '\\1ELSEIF client->check_on_navigated\\( \\)\\.\\n' + B +
        '\\1\\2view_display\\( \\)\\.$', 'm'));
      if (fork) {
        out.push({ line: lineOf(content, fork.index), text: 'both arms of the fork only call view_display( ) — drop the check_on_init branch, check_on_navigated( ) already covers the first start' });
      }
      return out;
    },
  },
  {
    // A mock table is read as a table, so its columns have to line up.
    // scripts/json-to-abap.mjs emits the padded form; this catches a
    // hand-written or hand-edited block that drifted. Only tables whose rows
    // carry the SAME field list are judged — where one row has a field the
    // next does not (an optional key, a nested child table) there is no column
    // to align. A block that would break the 255-character limit once padded
    // is wrapped by hand instead and is left alone here.
    id: 'ragged-value-table',
    level: 'error',
    doc: 'VALUE #( ) rows with the same field list are padded into columns, the last cell of a row unpadded (AGENTS §5); node scripts/json-to-abap.mjs emits that form',
    find(content) {
      const BT = String.fromCharCode(96);
      const ROW = new RegExp('^(\\s*)\\(((?: [a-z_0-9]+ = (?:' + BT + '[^' + BT + ']*' + BT + '|[^\\s()]+))+) \\)(.*)$');
      const CELL = new RegExp('([a-z_0-9]+) = (' + BT + '[^' + BT + ']*' + BT + '|[^\\s()]+)', 'g');
      const parse = (l) => {
        const m = l.match(ROW);
        if (!m) return null;
        const cells = [...m[2].matchAll(CELL)].map((c) => [c[1], c[2]]);
        return cells.length ? { indent: m[1], cells, suffix: m[3] } : null;
      };
      const L = content.split('\n');
      const out = [];
      let blk = [];
      const flush = () => {
        if (blk.length >= 3) {
          const rows = blk.map((i) => parse(L[i]));
          const keys = rows[0].cells.map((c) => c[0]).join('|');
          if (rows.every((r) => r.cells.map((c) => c[0]).join('|') === keys)) {
            const w = rows[0].cells.map((_, j) =>
              Math.max(...rows.map((r) => (r.cells[j][0] + ' = ' + r.cells[j][1]).length)));
            const built = rows.map((r) => r.indent + '( ' + r.cells
              .map(([k, v], j) => (j === r.cells.length - 1 ? k + ' = ' + v : (k + ' = ' + v).padEnd(w[j])))
              .join(' ') + ' )' + r.suffix);
            if (built.every((b) => b.length <= 255) && built.some((b, i) => b !== L[blk[i]])) {
              out.push({ line: blk[0] + 1, text: `${blk.length} rows of ${rows[0].cells.length} fields are not column-aligned` });
            }
          }
        }
        blk = [];
      };
      for (let i = 0; i < L.length; i++) { if (parse(L[i])) blk.push(i); else flush(); }
      flush();
      return out;
    },
  },
  {
    // Two parameters are not a reason for two lines. Outside the view chain,
    // which has its own layout, a statement that fits the budget is written on
    // one line — popover_display was split in all 35 of its call sites while
    // popup_display, its shorter sibling, was split in none of 43.
    // A wrapped t_arg list is deliberately exempt: it stays wrapped.
    id: 'stacked-short-call',
    level: 'error',
    doc: 'a statement outside the view chain that fits in 120 characters is written on ONE line (AGENTS §5)',
    find(content) {
      const BT = String.fromCharCode(96);
      const BUDGET = 120;
      const balanced = (s) => {
        let par = 0, bt = 0, pipe = 0;
        for (const ch of s) {
          if (ch === BT) bt++;
          else if (ch === '|') pipe++;
          else if (bt % 2 === 0 && pipe % 2 === 0) { if (ch === '(') par++; else if (ch === ')') par--; }
        }
        return par === 0 && bt % 2 === 0 && pipe % 2 === 0;
      };
      const squeeze = (s) => {
        let o = '', bt = false, pipe = false;
        for (const ch of s) {
          if (ch === BT) bt = !bt; else if (ch === '|') pipe = !pipe;
          if (ch === ' ' && !bt && !pipe && o.endsWith(' ')) continue;
          o += ch;
        }
        return o;
      };
      const forbidden = (l) => {
        const s = l.trim();
        if (!s || s.startsWith('"') || s.startsWith('*')) return true;
        if (l.includes('"')) return true;
        if (l.includes(')->') || l.includes('->a(') || l.includes('->ele(') || l.includes('->tag(')) return true;
        if (l.includes('t_arg')) return true;
        // the SECTIONS of a classic or RAP statement carry meaning stacked
        if (/\b(EXPORTING|IMPORTING|CHANGING|EXCEPTIONS|RECEIVING|TABLES|FAILED|REPORTED|MAPPED|RESPONSE|ENTITIES|ENTITY)\b/.test(l)) return true;
        // a string template split with && is a deliberate break for a long
        // literal - joined, abaplint then demands reduce_string_templates
        if (/&&\s*$/.test(l) || /^\s*&&/.test(l)) return true;
        if (/^\s*\( [a-z_0-9]+ = /.test(l)) return true;
        if (l.includes('VALUE #( (')) return true;
        return false;
      };
      const L = content.split('\n');
      const out = [];
      for (let i = 0; i < L.length; i++) {
        const a = L[i];
        const t = a.trim();
        if (forbidden(a) || t.endsWith('.') || !t.includes('(')) continue;
        for (const span of [2, 3]) {
          if (i + span > L.length) break;
          const block = L.slice(i, i + span);
          if (block.some(forbidden)) continue;
          if (block.slice(0, -1).some((l) => l.trim().endsWith('.'))) continue;
          if (!block[span - 1].trim().endsWith('.')) continue;
          const text = squeeze(block.map((l) => l.trim()).join(' '));
          if (!balanced(text)) continue;
          const line = ' '.repeat(a.length - a.trimStart().length) + text;
          if (line.length > BUDGET) continue;
          out.push({ line: i + 1, text: `${span} lines, ${line.length} characters on one — ${line.trim().slice(0, 70)}` });
          i += span - 1;
          break;
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

let errors = 0;
let warns = 0;
const seenBaseline = new Set();

// abapGit XML files MUST start with the UTF-8 BOM — abapGit serializes them
// that way, and BOM-less files break the format on the system pull (four
// crept in via agent-written files; human fix PR #38, 2026-07-27). The
// scaffolder and generate-overview both emit the BOM; this gates hand-written
// ones. Checked bytewise, outside the .clas.abap rule loop.
for (const f of walkFiles(SRC, '.xml')) {
  const rel = path.relative(ROOT, f).split(path.sep).join('/');
  const b = fs.readFileSync(f);
  if (!(b[0] === 0xEF && b[1] === 0xBB && b[2] === 0xBF)) {
    console.log(`ERROR ${rel}:1 [abapgit-xml-bom] file does not start with the UTF-8 BOM`);
    console.log('      abapGit XML must begin with EF BB BF — copy a reference clas.xml byte-exactly (PR #38 lesson, 2026-07-27)');
    errors++;
  }
}

for (const f of walkFiles(SRC, '.clas.abap')) {
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

// The generation prompt has to speak the builder the corpus is written in.
// It fell a rename behind once: the ports moved from z2ui5_cl_ai_xml to
// z2ui5_cl_ui5_view_builder and its open( )/leaf( )/shut( ) became
// ele( )/tag( )/end( ), but the prompt kept teaching the old three — and it
// is not only read here, mcp-server serves it to agents as `generation_rules`
// (see check-mcp-contract.mjs). Every port generated from it would have been
// written against methods that do not exist, and nothing said so.
const PROMPT = path.join(ROOT, 'scripts', 'generation-prompt.txt');
const RETIRED_VERBS = ['open', 'leaf', 'shut'];
if (fs.existsSync(PROMPT)) {
  const prompt = fs.readFileSync(PROMPT, 'utf8');
  const rel = path.relative(ROOT, PROMPT).split(path.sep).join('/');
  for (const verb of RETIRED_VERBS) {
    // the call shape only — `open the mvc:View` is prose, `open( ` is a claim
    const re = new RegExp(`\\b${verb}\\s*\\(`, 'g');
    for (const m of prompt.matchAll(re)) {
      console.log(`ERROR ${rel}:${lineOf(prompt, m.index)} [prompt-builder-verb] ${verb}( ) is not a method of z2ui5_cl_ui5_view_builder`);
      console.log('      the builder is ele( ) / tag( ) / a( ) / end( ) — the prompt is also served to agents as mcp-server generation_rules');
      errors++;
    }
  }
  for (const verb of ['ele', 'tag', 'end']) {
    if (!new RegExp(`\\b${verb}\\s*\\(`).test(prompt)) {
      console.log(`ERROR ${rel}:1 [prompt-builder-verb] the prompt never mentions ${verb}( )`);
      console.log('      it has to teach the four verbs the corpus is written in');
      errors++;
    }
  }
}

console.log(`\npattern-lint: ${errors} error(s), ${warns} warning(s), ` +
  `${seenBaseline.size}/${BASELINE.size} baseline entries matched.`);
process.exit(errors ? 1 : 0);
