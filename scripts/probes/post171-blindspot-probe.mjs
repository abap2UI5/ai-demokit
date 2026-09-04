#!/usr/bin/env node
/*
 * post171-blindspot-probe — find post-1.71 members the property gate CANNOT
 * see, used by a port that does not declare them.
 *
 * AGENTS §5 lists the residual limits of the property gate, and the review
 * sweep of 2026-08-21 confirmed every one of them is real debt in the corpus:
 * some ports declare these members, others do not, old and new alike. A green
 * `view_gates` says nothing here — that is the whole point of the list.
 *
 * The four shapes, all invisible to a gate that matches on ATTRIBUTE NAMES
 * against a control's own metadata:
 *
 *   relocated  the member predates 1.71 but now lives on a NEWER base class,
 *              so its @since reads as that base's version
 *              (NavigationListItem.expanded -> NavigationListItemBase @1.121)
 *   aggregation  an aggregation-level member, not a property
 *              (IconTabFilter.items @1.77 — app 221 declares exactly this)
 *   enum-value  the ATTRIBUTE is base-version, only one of its VALUES is new
 *              (CalendarDayType.NonWorking @1.121)
 *   missed     a plain property the snapshot has but no port declared
 *              (SideNavigation.width @1.120)
 *
 * This is a PROBE, not a gate: it reports, it does not fail a build. Every hit
 * needs a human verdict — a one-line POST_171 by policy, or a note saying why
 * the member is fine here. Add a row whenever a new blind-spot member turns
 * up; that is what keeps the lesson from having to be relearned.
 *
 *   node scripts/probes/post171-blindspot-probe.mjs
 *   node scripts/probes/post171-blindspot-probe.mjs --verbose   also list declared hits
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const META = path.join(ROOT, 'meta');
const VERBOSE = process.argv.includes('--verbose');

/* control: the owning control tag as the view builder spells it
 * member:  the attribute name, or the literal for an enum value
 * kind:    'attr' (attribute on that control) | 'value' (literal anywhere)
 * declare: the string a POST_171 deviation must mention to count as declared */
const BLIND_SPOTS = [
  { control: 'NavigationListItem', member: 'expanded', kind: 'attr', since: '1.121',
    shape: 'relocated', declare: 'expanded',
    note: 'the property predates 1.71 but moved to sap.tnt.NavigationListItemBase @1.121' },
  { control: 'SideNavigation', member: 'width', kind: 'attr', since: '1.120',
    shape: 'missed', declare: 'width',
    note: 'sap.tnt.SideNavigation.width @1.120' },
  { control: 'IconTabFilter', member: 'items', kind: 'attr', since: '1.77',
    shape: 'aggregation', declare: 'items',
    note: 'the nested sub-filter aggregation, aggregation-level and invisible to the gate' },
  { control: null, member: 'NonWorking', kind: 'value', since: '1.121',
    shape: 'enum-value', declare: 'NonWorking',
    note: 'sap.ui.unified.CalendarDayType.NonWorking @1.121 — an enum VALUE' },
  { control: null, member: 'Indication06', kind: 'value', since: '1.66',
    shape: 'enum-value', declare: 'Indication06',
    note: 'sap.ui.core.IndicationColor Indication06+ — the case AGENTS §5 names' },
];

// The chain linter guarantees one builder call per line, so the control a line
// belongs to is simply the most recent ele( )/tag( ) above it - INCLUDING the
// one that opens a chain off a handle (`bars->ele( \`IconTabBar\` )`), which is
// how every port continues a view after an end( ). Reading only the `)->ele(`
// form left the tracker holding the last control of the PREVIOUS chain, and
// app 620's `iconTabBarInlineIcons` items aggregation - an IconTabBar's - was
// reported as IconTabFilter.items @1.77, a member the port does not use.
const CONTROL_RE = /(?:\)|\w)->(?:ele|tag)\(\s*(?:n\s*=\s*)?`([^`]+)`/;
const ATTR_RE = /\)->a\(\s*n\s*=\s*`([^`]+)`/;

const metas = fs.readdirSync(META).filter((f) => f.endsWith('.json'))
  .map((f) => JSON.parse(fs.readFileSync(path.join(META, f), 'utf8')))
  .filter((m) => /^z2ui5_cl_smpc_app_\d+$/.test(m.class || ''));

const hits = [];
for (const m of metas) {
  const file = path.join(ROOT, m.file);
  if (!fs.existsSync(file)) continue;
  const src = fs.readFileSync(file, 'utf8');
  const lines = src.split('\n');
  const declaredText = (m.deviations || [])
    .filter((d) => d.type === 'POST_171' || d.type === 'DROPPED_171')
    .map((d) => d.what).join('\n');

  let control = null;
  for (const line of lines) {
    const c = CONTROL_RE.exec(line);
    if (c) control = c[1];
    for (const spot of BLIND_SPOTS) {
      let used = false;
      if (spot.kind === 'attr') {
        const a = ATTR_RE.exec(line);
        used = !!a && a[1] === spot.member && control === spot.control;
      } else {
        used = line.includes('`' + spot.member + '`');
      }
      if (!used) continue;
      const declared = declaredText.includes(spot.declare);
      if (declared && !VERBOSE) continue;
      hits.push({ cls: m.class, spot, declared });
    }
  }
}

// one row per (port, member) — a member used on ten items is one decision
const seen = new Set();
const rows = hits.filter((h) => {
  const k = `${h.cls}|${h.spot.member}`;
  if (seen.has(k)) return false;
  seen.add(k); return true;
});

const open = rows.filter((r) => !r.declared);
for (const r of rows) {
  const mark = r.declared ? 'declared ' : 'UNDECLARED';
  console.log(`${mark} ${r.cls}  ${r.spot.control ? r.spot.control + '.' : ''}${r.spot.member} @${r.spot.since} [${r.spot.shape}] — ${r.spot.note}`);
}
console.log(`\npost171-blindspot: ${metas.length} ports scanned, ${open.length} undeclared use(s) of a gate-blind post-1.71 member.`);
if (open.length) {
  console.log('Each needs a verdict: a one-line POST_171 by policy, or a note saying why it is fine here.');
}
