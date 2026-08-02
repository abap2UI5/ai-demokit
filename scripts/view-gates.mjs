#!/usr/bin/env node
/*
 * view-gates — the corpus side of abap2UI5-linter.
 *
 * The gates themselves live in @abap2ui5/linter, which was extracted from the
 * three scripts this replaces (property-check, structure-lint, render-smoke):
 * the view is reconstructed from the builder calls, every control and member
 * resolved against the UI5 metadata snapshot, the builder tree checked for
 * structural defects, and the whole thing rendered with a real XMLView.create
 * in headless Chromium against the OpenUI5 runtime.
 *
 * What stays here is the corpus POLICY - the part that is about ai-demokit
 * and not about abap2UI5 views in general:
 *
 *   - which ports are checked: the meta/ sidecars, not a directory walk
 *   - a post-1.71 member is allowed when a deviation NAMES it (AGENTS §5):
 *     1:1 fidelity wins, but the deviation has to be written down
 *   - a port may declare `render_smoke.skip` with a reason, and that skip is
 *     verified against the actual render: the moment the view renders clean
 *     the skip is stale and FAILS, so a skip can never quietly rot
 *   - findings the linter has learned since (accessibility, unhandled events,
 *     …) are reported as advisories rather than gating the corpus
 *
 *   node scripts/view-gates.mjs               advisory report
 *   node scripts/view-gates.mjs --strict      exit 1 on any violation
 *   node scripts/view-gates.mjs --no-render   the static gates only (no browser)
 *   node scripts/view-gates.mjs --only 164    one port
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { checkFiles } from '@abap2ui5/linter';
import { severityOf } from '@abap2ui5/linter/findings';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const STRICT = process.argv.includes('--strict');
const RENDER = !process.argv.includes('--no-render');
const ONLY = process.argv.includes('--only')
  ? process.argv[process.argv.indexOf('--only') + 1]
  : null;

/** The version floor every port is held to. */
const MIN_UI5 = '1.71';

/* Version findings are the ones a deviation may excuse: using a member the
 * original sample uses is fidelity, and the porting policy allows it as long
 * as the sidecar names it. Everything else is a defect, not a choice. */
const VERSION_TYPES = new Set(['control-too-new', 'member-too-new', 'event-parameter-too-new']);

/* Reported, never gating: rules the linter grew after this corpus was built.
 * They are worth seeing on every run - an icon-only button really is unusable
 * with a screen reader - but turning 37 of them into a red build is a
 * decision for the corpus, not a side effect of upgrading the linter. */
const ADVISORY_TYPES = new Set(['missing-accessibility', 'event-without-handler']);

const metas = fs.readdirSync(META)
  .filter((f) => f.endsWith('.json'))
  .sort()
  .map((f) => JSON.parse(fs.readFileSync(path.join(META, f), 'utf8')))
  .filter((m) => !ONLY || m.class.endsWith(`_${ONLY}`))
  .filter((m) => fs.existsSync(path.join(ROOT, m.file)));

if (!metas.length) {
  console.error(ONLY ? `view-gates: no port matching --only ${ONLY}` : 'view-gates: no ports found');
  process.exit(1);
}

const byFile = new Map(metas.map((m) => [path.join(ROOT, m.file), m]));
const results = await checkFiles([...byFile.keys()], {
  minUi5: MIN_UI5,
  render: RENDER,
  properties: true,
});

/** A deviation excuses a finding when it NAMES what the finding is about -
 *  the same loose match the property gate has always used: the deviation is
 *  prose, and what matters is that a human wrote it down and explained it.
 *  A control is looked up by its local name too, because that is how the
 *  sidecars refer to it ("the NotificationList container control (since UI5
 *  1.90) ... invisible to the member-level property gate"). */
function declares(meta, finding) {
  const names = [finding.member, finding.control, String(finding.control || '').split('.').pop()]
    .filter(Boolean)
    .map((n) => n.toLowerCase());
  if (!names.length) return false;
  return (meta.deviations || [])
    .map((d) => String(d.what || '').toLowerCase())
    .some((text) => names.some((n) => text.includes(n)));
}

let failing = 0;
let skipped = 0;
let advisories = 0;
const lines = [];

for (const r of results) {
  const meta = byFile.get(r.file);
  const cls = meta.class;
  const declaredSkip = meta.render_smoke?.skip === true;

  /* A port whose view parts are built in helper methods cannot be
   * reconstructed statically, so the render gate is skipped - but only ever
   * with a declared reason. An undeclared one is a failure, not a silent gap. */
  if (r.skippedRender) {
    if (declaredSkip) {
      skipped++;
      lines.push(`SKIP  ${cls}  (declared render_smoke.skip: ${r.helperTokens} builder call(s) in helper methods)`);
    } else {
      failing++;
      lines.push(`FAIL  ${cls}  (${r.helperTokens} builder call(s) in helper methods — not statically reconstructable and no render_smoke.skip declared)`);
      continue;
    }
  }

  const violations = [];
  const advisory = [];
  for (const f of r.findings) {
    if (ADVISORY_TYPES.has(f.type)) { advisory.push(f); continue; }
    if (VERSION_TYPES.has(f.type) && declares(meta, f)) continue;
    if (severityOf(f) === 'hint') { advisory.push(f); continue; }
    violations.push(f);
  }

  /* The render skip is verified against the real render: honoured only while
   * the view still errors. The moment it renders clean the skip is stale. */
  let renderErrors = r.renderErrors;
  if (RENDER && declaredSkip && !r.skippedRender) {
    if (renderErrors.length) {
      skipped++;
      lines.push(`SKIP  ${cls}  (declared render_smoke.skip, still erroring: ${renderErrors[0].slice(0, 90)})`);
      renderErrors = [];
    } else {
      violations.push({
        type: 'stale-skip',
        message: 'declares render_smoke.skip but renders clean — remove the skip',
      });
    }
  }

  advisories += advisory.length;
  if (!violations.length && !renderErrors.length) {
    if (!r.skippedRender && !declaredSkip) {
      lines.push(`pass  ${cls}${r.docs.length ? `  (${r.docs.length} doc(s))` : ''}`);
    }
  } else {
    failing++;
    lines.push(`FAIL  ${cls}`);
    for (const f of violations) {
      const where = f.line ? `${meta.file}:${f.line}` : meta.file;
      lines.push(`  ! ${where} — ${f.message}`);
    }
    for (const e of renderErrors) lines.push(`  ! render: ${e.slice(0, 200)}`);
  }
  for (const f of advisory) {
    lines.push(`  · ${f.line ? `${meta.file}:${f.line}` : meta.file} — ${f.message}`);
  }
}

console.log(lines.join('\n'));
console.log(
  `\nview-gates: ${results.length} ports, ${failing} failing, ${skipped} skipped, `
  + `${advisories} advisory (target SAPUI5 ${MIN_UI5}${RENDER ? ', render gate on' : ', render gate off'}).`
);
if (STRICT && failing) process.exit(1);
