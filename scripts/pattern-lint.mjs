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
    id: 'event-arg-bare-brace',
    level: 'error',
    doc: 'event t_arg uses a bare `{COL}` — not resolved by get_event_arg; use the $-prefixed form (${COL}) — AGENTS §5, bit us in app 526',
    find(content) {
      const out = [];
      const re = /t_arg\s*=/g;
      let m;
      while ((m = re.exec(content))) {
        const open = content.indexOf('(', re.lastIndex);
        if (open === -1) continue;
        const region = parenRegion(content, open);
        for (const lit of region.matchAll(/`([^`]*)`/g)) {
          if (/^\{/.test(lit[1])) {
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
    id: 'obsolete-bind',
    level: 'error',
    doc: 'client->_bind( is obsolete — always use _bind_edit — AGENTS §5',
    find: grepLines(/->_bind\(/),
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
    doc: 'client handle strings (_event, _bind_edit, _event_client, ...) are written inline at each control, never captured in a variable - even when repeated, even in expression bindings (human decision 2026-07-17, apps 526/486/421)',
    find: grepLines(/DATA\(\w+\)\s*=\s*client->_\w+\(/),
  },
  {
    id: 'param-continuation-align',
    level: 'warn',
    doc: 'a t_arg continuation line must start in the same column as the val parameter above it — human-taught alignment fix, 2026-07-16 (apps 421/422)',
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

function walk(dir, out = []) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else if (full.endsWith('.clas.abap')) out.push(full);
  }
  return out;
}

let errors = 0;
let warns = 0;
const seenBaseline = new Set();

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
  `${seenBaseline.size}/${BASELINE.size} baseline entrie(s) matched.`);
process.exit(errors ? 1 : 0);
