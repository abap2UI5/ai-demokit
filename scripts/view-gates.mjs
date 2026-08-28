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

/* The metadata snapshot the linter judges against, read here so a sidecar's
 * CLAIM about a member's @since can be checked against the same source the
 * gate itself uses. */
const PROPS = JSON.parse(fs.readFileSync(
  path.join(ROOT, 'node_modules', '@abap2ui5', 'linter', 'data', 'properties.json'), 'utf8'));

/** The declared @since of one member, or null when the snapshot has no entry -
 *  which is a metadata gap, never evidence about the member. */
function memberSince(control, member) {
  const c = PROPS.controls?.[control];
  if (!c) return null;
  for (const section of ['properties', 'aggregations', 'associations', 'events']) {
    const since = c[section]?.[member]?.since;
    if (since) return since;
  }
  return null;
}

/** Is `since` at or below the floor, i.e. NOT post-1.71? */
function withinFloor(since) {
  const a = String(since).split('.').map(Number);
  const b = MIN_UI5.split('.').map(Number);
  for (let i = 0; i < Math.max(a.length, b.length); i++) {
    const x = a[i] || 0; const y = b[i] || 0;
    if (x !== y) return x < y;
  }
  return true;
}

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
const ADVISORY_TYPES = new Set(['missing-accessibility', 'event-without-handler']);

/* …but "never gating" must not mean "growing unnoticed": the RATCHET pins the
 * accepted advisory debt per finding type. The existing findings stay
 * tolerated; a batch that ADDS one fails strict, and a batch that removes
 * some prints the lower number so the budget can be ratcheted down in the
 * same change. An advisory type with no entry here has budget 0 - a linter
 * bump that introduces a new advisory rule surfaces at the bump PR, where the
 * debt decision belongs, instead of accruing silently.
 * Counts pinned 2026-08-04. */
const ADVISORY_BUDGET = {
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
  // raised 2026-08-22 (batch b33, app 431 ContainerResponsivePadding): one more
  // of the same shape - the icon-only settings / drop-down-list Buttons the
  // sample puts in the Panel's header Toolbar without a tooltip; kept 1:1
  // raised 2026-08-22 (batch b34, app 440 MenuEndContent): one more of the same
  // shape - the transparent icon-only Buttons the sample puts in its MenuItem
  // endContent, tooltip-less in the demo kit fragment itself; kept 1:1
  // raised 2026-08-22 (batch b41, app 508 ListToolbar): one more of the same
  // shape - the three icon-only Buttons in the List's header OverflowToolbar,
  // tooltip-less in the demo kit sample itself; kept 1:1
  // raised 2026-08-22 (batch b42, app 522 ListLoading): one more of the same
  // shape - the icon-only refresh Button in the List's header OverflowToolbar,
  // tooltip-less in the demo kit sample itself; kept 1:1
  // raised 2026-08-22 (batch b44, app 541 PlanningCalendarWithLegend): one more
  // of the same shape - the icon-only legend ToggleButton in the calendar's
  // toolbar, tooltip-less in the demo kit sample itself; kept 1:1
  // raised 2026-08-22 (batch b46, catching up on batch b45): three of the same
  // shape that b45 landed without raising the budget, so the ratchet has been
  // red since that commit - app 553's icon-only legend ToggleButton and app
  // 554's legend ToggleButton plus its icon-only Button, all tooltip-less in
  // the demo kit samples themselves; kept 1:1. Batch b46 (apps 556-565) adds
  // none: every icon-only button it ports got a tooltip
  // ratcheted down 2026-08-14 with the linter bump to 51cce10: 6afb902
  // ("missing-accessibility: stop asking for an attribute UI5 ignores") drops
  // the findings on controls where the attribute is ignored anyway, so 26 of
  // the 55 were never real. The ones above stay — they are the alt/tooltip-less
  // originals, kept 1:1
  'missing-accessibility': 37,
  'event-without-handler': 5, // ratcheted down 2026-08-05: the four calendar ports wired their select handler
  // raised 2026-08-23 (app 600 TreeDnD): a wire that exists ONLY to carry
  // prevent_default_expr. The sample's onDragStart vetoes a drag starting
  // outside the current selection - a condition known per firing, so
  // check_prevent_default (baked per wire at render time) cannot express it and
  // the wire was previously dropped. on_event deliberately ignores DRAG_START:
  // the veto is already decided on the client by the time the event lands, and
  // the round trip is what carrying the expression costs. "Dead control unless
  // the roundtrip alone is intended" is exactly the case here, and the
  // interaction module proves all three outcomes (no selection: drag allowed;
  // outside the selection: vetoed; on the selected row: allowed)
  // raised 2026-08-21 (app 298, sap.m.table.columnmenu.QuickSort): the same
  // shape as 268, and here the metadata is not merely incomplete but WRONG.
  // QuickSort.change declares `key` and `sortOrder` and fires neither —
  // onChange does `this.fireChange({item: oItem})` and nothing else
  // (node_modules/@openui5/sap.m/src/sap/m/table/columnmenu/QuickSort.js:85).
  // Reading the declared names is what the linter would accept and what
  // delivers two empty strings at runtime, so the port reads `item`, like the
  // sample's own onSortChange does. Satisfying this rule here would mean
  // breaking the port.
  // raised 2026-08-22 (batch b47, app 571 TableIColumnHeaderMenu): the SAME
  // QuickSort.change metadata gap app 298 documents above - the event declares
  // key and sortOrder and fires neither, so this port reads the `item` the
  // control really passes, exactly as the sample's own handler does
  'unknown-event-parameter': 3, // app 268: ColorPickerPopover forwards colorString undeclared — works live
  // both entries below are new rules from the 2026-08-12 linter bump (363c6e9),
  // budgeted here because the bump PR is where the debt decision belongs:
  // apps 101/102/144/268/280/407 — a liveChange/live wire that round-trips per
  // keystroke. Every one is the sample's POINT (live name validation, the live
  // Slider/ColorPicker/SearchField readout), so the original's live handler is
  // what a 1:1 port carries; the final-value event the rule prefers would be a
  // fidelity deviation, not a fix
  // raised 2026-08-22 (batch b36, app 462 InputValueUpdate): the same shape -
  // the sample exists to COMPARE oInput.getValue() with the model property, so
  // the getValue Text has to follow every keystroke; a final-value event would
  // erase the difference the sample demonstrates
  // ratcheted down 2026-08-28 to 10: app 462 no longer round-trips at all. Its
  // liveChange is a roundtrip-free follow_up_action control_by_id setText since
  // the A2UI5_PIN bump to 2567ee10 carried abap2UI5's control-action-empty-
  // string-arg fix, so the entry above is spent - the port kept the live wire
  // and lost the round trip
  // raised 2026-08-22 (batch b40, app 499 ListSelectionSearch): the sample's own
  // SearchField wires liveChange to the list filter, so the search IS the live
  // wire; a final-value event would change what the sample demonstrates
  // raised 2026-08-22 (batch b46, and catching up on batch b43): three of the
  // same shape, two of which b43 landed without raising the budget, so the
  // ratchet has been red since that commit - apps 533/535 and now 560, the
  // wizard samples whose per-keystroke liveChange IS the step validation
  // (validateStep/invalidateStep at three characters); a final-value event
  // would gate the Next button one keystroke late
  'live-event-roundtrip': 10,
  // raised 2026-08-28 (app 462 InputValueUpdate): the rule asks for a two-way
  // binding instead of a setText action, and this is the one port where that
  // would break the sample. InputValueUpdate exists to COMPARE
  // oInput.getValue() with the model property while valueLiveUpdate is off -
  // i.e. exactly while the two disagree - so a bound Text would show the model
  // value and the sample would demonstrate nothing. The original's own
  // controller writes it imperatively (`this.byId('getValue').setText(...)`),
  // which is what this port now does on the client with no round trip. The
  // "survives a view rebuild" half of the rule's reasoning does not apply
  // either: the value is a keystroke echo, and the original loses it on a
  // rebuild too
  'settable-property-via-action': 1,
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
  // ratcheted down 2026-08-27 to 4, and the "keep it there" above is now spent:
  // it guarded against an UNDER-count from the reconstructor gap, and this drop
  // is not one. App 121 no longer fires because #148 gave it a real fix - the
  // Button's `enabled` is `client->_bind( version_enabled )`, a bound flag the
  // radio group flips, which is precisely what the rule's message asks for
  // ("bind enabled if it should ever flip"). The four below are still the
  // literal enabled="false" samples that exist to SHOW the disabled control.
  // Measured on the 0.5.1 bump; the count was already 4 on 0.4.1, so this is
  // pre-existing slack the bump surfaced rather than anything the bump moved.
  'event-on-disabled-control': 4,
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

  /* Only a POST_171 or DROPPED_171 may excuse a VERSION finding. This is the
   * whole meaning of those two types — "this member is newer than the floor
   * and the port keeps it / drops it deliberately" — and until 2026-08-21 any
   * deviation would do, which made the escape far wider than intended:
   * app 268 kept ColorPickerPopover.liveChange (@since 1.85) with only a NOTE
   * that happened to say "the liveChange round-trip keeps the Text …", and
   * that sentence silently satisfied the gate, leaving a post-1.71 port filed
   * in src/01. A NOTE describing what a member DOES is not a declaration that
   * it is too new; the type is what carries that claim, and it is also what
   * moves the class to src/02. */
  const relevant = (meta.deviations || [])
    .filter((d) => d.type === 'POST_171' || d.type === 'DROPPED_171')
    .map((d) => String(d.what || '').toLowerCase());
  return relevant.some((text) => names.some((n) => text.includes(n)));
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
  /* A sidecar may declare `property_gate: { skip: true, reason, types: [...] }`
   * for the case the corpus keeps meeting: the UI5 metadata says one thing and
   * the control's own code does another, so satisfying the rule would mean
   * breaking the port. It is deliberately narrower than the render / data /
   * structural skips - it must NAME the finding types it covers, and a named
   * type that does not fire is stale and fails the port, exactly like a stale
   * render skip. */
  const gateSkip = meta.property_gate?.skip === true ? meta.property_gate : null;
  const skipUsed = new Set();
  for (const f of r.findings) {
    if (ADVISORY_TYPES.has(f.type)) { advisory.push(f); continue; }
    if (VERSION_TYPES.has(f.type) && declares(meta, f)) continue;
    if (gateSkip && gateSkip.types.includes(f.type)) { skipUsed.add(f.type); continue; }
    if (severityOf(f) === 'hint') { advisory.push(f); continue; }
    violations.push(f);
  }
  /* A POST_171 whose claim the snapshot CONTRADICTS. The excuse check above
   * runs in one direction only: a version finding is accepted when a POST_171
   * names it, and nothing ever asked whether the POST_171 is true. That is not
   * a harmless kind of wrong — per AGENTS §3 the first POST_171 is also what
   * files the class under src/02/<lib>/ instead of src/01/<lib>/. App 443
   * declared "sap.m.Text.renderWhitespace is @since 1.89"; it is @since 1.51
   * (1.89 belongs to Link.emptyIndicatorMode), and on that the port sat in
   * src/02 for two weeks with a wrong stated runtime floor.
   *
   * Deliberately narrow. It judges ONE shape — a deviation naming
   * <Control>.<member> together with an @since — and only fires when the
   * snapshot resolves that member and says it is NOT newer than the floor.
   * Everything else stays silent, which matters because the most valuable
   * POST_171s are the ones the property gate cannot see at all: an
   * aggregation-level dependency (app 079), a formatOptions value inside a
   * binding string (135), a core:require on the view root (139). "No finding
   * fired" is therefore NOT evidence of a false declaration — that was the
   * first cut of this check and it flagged 19 ports, nearly all of them
   * correct. A member the snapshot does not carry is also left alone: that is
   * the metadata gap, not a wrong claim. */
  for (const d of (meta.deviations || []).filter((x) => x.type === 'POST_171')) {
    const text = String(d.what || '');
    /* The pair has to be ADJACENT and the claim has to be that the member is
     * TOO NEW. Both halves are load-bearing. A good deviation names members it
     * is NOT about: app 292 declares the enum VALUE
     * sap.m.PanelBackgroundDesign.Contrast and mentions "backgroundDesign
     * itself is @since 1.30" precisely to explain why the member-level check
     * cannot see it. Matching the member anywhere in the prose flagged that;
     * requiring the adjacent version AND requiring it to be above the floor
     * separates "the sidecar asserts this is too new" from "the sidecar
     * explains that it is not". */
    for (const m of text.matchAll(/\b(sap(?:\.\w+)+)\.(\w+)\b[^.]{0,60}?@?since\s+(?:UI5\s+)?(?:version\s+)?(\d+\.\d+(?:\.\d+)?)/gi)) {
      if (withinFloor(m[3])) continue;   // the sidecar is not claiming it is too new
      const decl = memberSince(m[1], m[2]);
      if (decl && withinFloor(decl)) {
        violations.push({
          type: 'unfounded-post171',
          message: `POST_171 claims ${m[1]}.${m[2]} is @since ${m[3]}, but the metadata says @since ${decl} — not newer than the floor`
            + ' — and a POST_171 is also what files the class under src/02',
        });
      }
    }
  }
  if (gateSkip) {
    for (const t of gateSkip.types) {
      if (!skipUsed.has(t)) {
        violations.push({
          type: 'stale-skip',
          message: `declares property_gate for "${t}" but no such finding fires — remove it`,
        });
      }
    }
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
