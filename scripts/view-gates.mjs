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
import { badgeEndpoint, runStats } from '@abap2ui5/linter/report';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const STRICT = process.argv.includes('--strict');
const RENDER = !process.argv.includes('--no-render');
const ONLY = process.argv.includes('--only')
  ? process.argv[process.argv.indexOf('--only') + 1]
  : null;
if (process.argv.includes('--only') && !ONLY) {
  console.error('view-gates: --only needs a class name (e.g. --only z2ui5_cl_smpc_app_001)');
  process.exit(2);
}

/** The version floor every port is held to. */
const MIN_UI5 = '1.71';

/* Version findings are the ones a deviation may excuse: using a member the
 * original sample uses is fidelity, and the porting policy allows it as long
 * as the sidecar names it. Everything else is a defect, not a choice. */
/* `aggregation-too-new` is the linter's 2026-08 split of `member-too-new`: an
 * aggregation TAG newer than the floor is an error rather than a warning,
 * because UI5 resolves the unknown lowercase tag as a control class and the
 * 404 takes the whole view down instead of dropping one attribute. It is a
 * version finding like the others, so a POST_171 deviation naming the
 * aggregation excuses it exactly as before — 24 ports on this corpus depend
 * on that, and without this entry a linter bump would fail every one of them.
 * `icon-too-new` joins for the same reason: same floor, same deviation. */
const VERSION_TYPES = new Set(['control-too-new', 'member-too-new', 'aggregation-too-new',
  'event-parameter-too-new', 'enum-value-too-new', 'icon-too-new']);

/* Reported, never gating per finding: rules the linter grew after this corpus
 * was built. They are worth seeing on every run - an icon-only button really
 * is unusable with a screen reader - but turning 41 of them into a red build
 * is a decision for the corpus, not a side effect of upgrading the linter. */
const ADVISORY_TYPES = new Set(['missing-accessibility', 'event-without-handler',
  'missing-on-navigated-branch']);

/* …but "never gating" must not mean "growing unnoticed": the RATCHET pins the
 * accepted advisory debt per finding type. The existing findings stay
 * tolerated; a batch that ADDS one fails strict, and a batch that removes
 * some prints the lower number so the budget can be ratcheted down in the
 * same change. An advisory type with no entry here has budget 0 - a linter
 * bump that introduces a new advisory rule surfaces at the bump PR, where the
 * debt decision belongs, instead of accruing silently.
 * Counts pinned 2026-08-04. */
const ADVISORY_BUDGET = {
  /* Added with the 0.2.0 linter bump, and it is the largest single entry this
   * ratchet has ever carried: EVERY port. `main( )` here dispatches on
   * check_on_init( ) alone, so nothing re-displays when a called app or a
   * popup hands control back, or when a bookmarked state is restored.
   *
   * It is not a false positive and it is not a fidelity deviation — this
   * repository decided the branch is mandatory in #102, and its own generated
   * README now says so word for word: "The check_on_navigated branch is NOT
   * optional and stays even in a static app with no data and no events."
   * The demo kit originals have no such branch because they are not abap2UI5
   * apps; a port has to carry the framework's lifecycle either way.
   *
   * Budgeted rather than gating, because turning 416 ports red on a linter
   * bump is the side effect the comment below warns against — but this budget
   * is DEBT, not a tolerated shape like the alt-less logos. It must ratchet to
   * zero as the ports are regenerated: the generation prompt already emits the
   * branch, so a re-port fixes it, and every batch should lower this number. */
  'missing-on-navigated-branch': 416, // every port, measured 2026-08-16 on the 0.2.0 bump
  // raised 2026-08-09 (batch b08, sap.tnt): the two ToolPage ports keep the
  // original's alt-less sap.m.Image logo 1:1 — adding an alt would invent text
  // raised 2026-08-10 (batch b19, app 350 ProductHomeLayout): the same shape —
  // a tnt:ToolHeader with the alt-less SAP logo Image and the icon-only
  // search/bell Buttons the sample gives no tooltip; both kept 1:1
  // raised 2026-08-12 (batches b25–b28 + uxap b07, the samples-repo backlog):
  // five more of the same shape — the alt-less sap.m.Image in apps 397/399
  // (img>/products/pic1) and 401 (the uxap linkedin/Twitter icons), and the
  // icon-only Buttons apps 395/397 inherit from their OverflowToolbar
  // originals. Every one is alt/tooltip-less in the demo kit sample itself,
  // so supplying one would invent text the original does not have
  // raised 2026-08-12 (batch b30, apps 405/406 PageListReport*): two more of
  // the same shape — the icon-only group-2 / action-settings Buttons in the
  // AnalyticalTable's OverflowToolbar extension, tooltip-less in both demo kit
  // samples; a tooltip here would be invented text, not a port
  // raised 2026-08-12 (batch b08 uxap, apps 413/414/417): three more of the
  // same shape — the alt-less social-icon / profile sap.m.Images the
  // ObjectPageHeader samples ship without alt; kept 1:1, an alt would be
  // invented text
  // ratcheted down 2026-08-14 with the linter bump to 51cce10: 6afb902
  // ("missing-accessibility: stop asking for an attribute UI5 ignores") drops
  // the findings on controls where the attribute is ignored anyway, so 26 of
  // the 55 were never real. The ones above stay — they are the alt/tooltip-less
  // originals, kept 1:1
  'missing-accessibility': 29,
  'event-without-handler': 4, // ratcheted down 2026-08-05: the four calendar ports wired their select handler
  'unknown-event-parameter': 1, // app 268: ColorPickerPopover forwards colorString undeclared — works live
  // both entries below are new rules from the 2026-08-12 linter bump (363c6e9),
  // budgeted here because the bump PR is where the debt decision belongs:
  // apps 101/102/144/268/280/407 — a liveChange/live wire that round-trips per
  // keystroke. Every one is the sample's POINT (live name validation, the live
  // Slider/ColorPicker/SearchField readout), so the original's live handler is
  // what a 1:1 port carries; the final-value event the rule prefers would be a
  // fidelity deviation, not a fix
  'live-event-roundtrip': 6,
  // apps 005/080/121/127/236 — a press/post wired next to a LITERAL
  // enabled="false". The rule doc grants this exact case ("a 1:1 port of a
  // sample demonstrating the disabled STATE legitimately carries the original's
  // handler") - all five samples exist to SHOW the disabled control.
  // All five ARE counted since the 2026-08-14 linter bump (0168979): its
  // reconstructor knew `_event_client` but not `follow_up_action`, so after
  // the rename the four frontend wires were dropped from the reconstructed
  // view instead of judged and only app 121 reached the tally. The budget was
  // deliberately left at the TRUE count of 5 for exactly this moment, and the
  // count landed on 5 - keep it there rather than ratcheting
  'event-on-disabled-control': 5,
};

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
  /* `value` carries the name for the findings that have no control/member of
   * their own — an icon finding names the glyph there and nothing else, so
   * without it it could never be excused by a deviation, whatever
   * VERSION_TYPES says.
   *
   * Matched as the full `sap-icon://<name>` and NOT as the bare name, because
   * the match below is a SUBSTRING match: icon names go down to two letters
   * (`da`, `e-care`, `ai`), and `da` occurs inside "data", "standard" and
   * "update". App 134 was excused by a NOTE about verbatim Cyrillic homoglyphs
   * that happened to contain the letters — a deviation silently covering a
   * finding it never mentioned is worse than no deviation at all. Spell the
   * URI in the deviation and it is unambiguous. */
  const names = [finding.member, finding.control, String(finding.control || '').split('.').pop(),
    finding.type.startsWith('icon-') ? `sap-icon://${finding.value}` : null]
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
const advisoryTally = new Map(); // finding type -> count, for the ratchet
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
  for (const f of advisory) advisoryTally.set(f.type, (advisoryTally.get(f.type) || 0) + 1);
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

/* The ratchet: compare the advisory tally against the pinned budget. Only on
 * full runs - a --only subset would read as "the debt shrank". */
let ratchetExceeded = 0;
if (!ONLY) {
  const types = new Set([...advisoryTally.keys(), ...Object.keys(ADVISORY_BUDGET)]);
  for (const type of [...types].sort()) {
    const n = advisoryTally.get(type) || 0;
    const budget = ADVISORY_BUDGET[type] ?? 0;
    if (n > budget) {
      ratchetExceeded++;
      console.log(`FAIL advisory ratchet: ${type} ${n} > budget ${budget} — new advisory debt; fix it or raise the budget deliberately (scripts/view-gates.mjs ADVISORY_BUDGET)`);
    } else if (n < budget) {
      console.log(`note: advisory budget for ${type} can ratchet down to ${n} (currently ${budget})`);
    }
  }
}

console.log(
  `\nview-gates: ${results.length} ports, ${failing} failing, ${skipped} skipped, `
  + `${advisories} advisory (target SAPUI5 ${MIN_UI5}${RENDER ? ', render gate on' : ', render gate off'}).`
);

/* The two README badges — the same pair abap2UI5/samples and
 * abap2UI5/samples-stack carry, written from the same linter helper so all
 * three read alike. They are written HERE rather than by `abap2ui5lint
 * --badge`, because the CLI has never seen this corpus' policy: it would
 * count the 24 aggregation-too-new findings a POST_171 deviation excuses and
 * the declared render skips as problems, and report a red badge over a green
 * gate. The verdict below is the gate's own.
 *
 * Only a FULL run with the render gate on may write them: `--only` sees one
 * port and `--no-render` sees fewer gates, and either would overwrite the
 * badges of the real run with a smaller truth. Same reason check-abap2UI5
 * passes --no-badge to its markdown second pass in the other two repos. */
if (!ONLY && RENDER) {
  const stats = runStats(results);
  /* Shaped like the linter's own summarize(), with the gate verdict in place
   * of the raw finding counts: a failing port is an error, and an advisory is
   * deliberately not a problem — the ratchet is what holds those, per type,
   * and a badge that counted them would move on debt the budget already
   * pins. `files` drives the "nothing checkable" grey, which is the state
   * this badge exists to make visible. */
  const verdict = failing + ratchetExceeded;
  const summary = {
    files: results.length,
    skipped,
    totals: { error: verdict, warning: 0, hint: 0 },
    problems: verdict,
  };
  for (const badge of [
    { kind: 'corpus', file: '.github/badges/abap2ui5.json' },
    { kind: 'checks', file: '.github/badges/check-abap2ui5.json' },
  ]) {
    const file = path.join(ROOT, badge.file);
    fs.mkdirSync(path.dirname(file), { recursive: true });
    fs.writeFileSync(file, `${JSON.stringify(badgeEndpoint(summary, stats, { kind: badge.kind }), null, 2)}\n`);
    console.log(`badge: wrote ${badge.file}`);
  }
}

if (STRICT && (failing || ratchetExceeded)) process.exit(1);
