/*
 * capabilities — CAPABILITIES.md as a queryable, machine-readable index.
 *
 * CAPABILITIES.md is the hand-maintained source of truth (AGENTS.md §10 keeps
 * it honest: every entry names a proving port). This module parses its tables
 * ON EVERY QUERY, so there is no generated artifact that can drift — what the
 * agent sees is always exactly what the file says.
 *
 * Parsed shape per entry:
 *   { section, feature, status, statusText, how, evidence }
 * status: 'direct' | 'workaround' | 'needs-live-test' | 'not-expressible'
 * (the CAPABILITIES.md legend marks in that order).
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

export const REPO_ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const CAPABILITIES_MD = path.join(REPO_ROOT, 'CAPABILITIES.md');

// status marks from the CAPABILITIES.md legend, built from code points so this
// source file stays 7-bit ASCII (repo convention for embedded/linted sources)
const MARK_DIRECT = String.fromCodePoint(0x2705); // white heavy check mark
const MARK_WORKAROUND = String.fromCodePoint(0x1f536); // large orange diamond
const MARK_LIVE_TEST = String.fromCodePoint(0x1f9ea); // test tube
const MARK_NO = String.fromCodePoint(0x274c); // cross mark

const STATUS_BY_MARK = [
  [MARK_DIRECT, 'direct'],
  [MARK_WORKAROUND, 'workaround'],
  [MARK_LIVE_TEST, 'needs-live-test'],
  [MARK_NO, 'not-expressible'],
];

function statusOf(cell) {
  for (const [mark, status] of STATUS_BY_MARK) {
    if (cell.includes(mark)) return status;
  }
  return null;
}

// split one markdown table row into cells; a \| escape inside a cell survives
const PIPE_TOKEN = '\u0001';
function cells(line) {
  return line
    .replace(/\\\|/g, PIPE_TOKEN)
    .split('|')
    .slice(1, -1)
    .map((c) => c.replaceAll(PIPE_TOKEN, '|').trim());
}

export function parseCapabilities() {
  const text = fs.readFileSync(CAPABILITIES_MD, 'utf8');
  const entries = [];
  let section = '';
  for (const line of text.split('\n')) {
    const h = line.match(/^##\s+(.*)/);
    if (h) {
      section = h[1].trim();
      continue;
    }
    if (!line.startsWith('|') || /^\|[\s:-]+\|/.test(line)) continue;
    const c = cells(line);
    if (c.length < 4 || c[0] === 'UI5 feature') continue;
    const status = statusOf(c[1]);
    if (!status) continue;
    entries.push({ section, feature: c[0], status, statusText: c[1], how: c[2], evidence: c[3] });
  }
  return entries;
}

export function searchCapabilities({ query, status } = {}) {
  let entries = parseCapabilities();
  if (status) entries = entries.filter((e) => e.status === status);
  if (query) {
    const terms = query.toLowerCase().split(/\s+/).filter(Boolean);
    entries = entries.filter((e) => {
      const hay = `${e.section} ${e.feature} ${e.how} ${e.evidence}`.toLowerCase();
      return terms.every((t) => hay.includes(t));
    });
  }
  return entries;
}

export function capabilitySummary() {
  const entries = parseCapabilities();
  const bySection = {};
  const byStatus = {};
  for (const e of entries) {
    bySection[e.section] = (bySection[e.section] || 0) + 1;
    byStatus[e.status] = (byStatus[e.status] || 0) + 1;
  }
  return { total: entries.length, bySection, byStatus };
}
