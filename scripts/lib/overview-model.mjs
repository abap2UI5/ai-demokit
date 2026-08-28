/*
 * overview-model — the overview app's MODEL: one row per ported sample, joined
 * from the meta/ sidecars, the sample-universe snapshot and the port's own
 * ABAP source, with the rating and the flags the view filters on.
 *
 * The second seam out of generate-overview.mjs (2026-08-28). Everything here
 * answers "what is true about this port"; nothing here knows what ABAP looks
 * like. The code is unchanged across the split.
 */
import fs from 'fs';
import path from 'path';

// compare dotted UI5 versions ("1.86" > "1.77"); '' (unknown / since forever) is lowest
const verCmp = (a, b) => {
  const pa = String(a).split('.').map(Number), pb = String(b).split('.').map(Number);
  for (let i = 0; i < Math.max(pa.length, pb.length); i++) {
    const d = (pa[i] || 0) - (pb[i] || 0);
    if (d) return d;
  }
  return 0;
};
const verMax = (a, b) => (!a ? b : !b ? a : verCmp(a, b) >= 0 ? a : b);

/**
 * @param {object}   o
 * @param {string}   o.ROOT       repository root
 * @param {string}   o.META       the meta/ directory
 * @param {Map}      o.uniMap     `<lib>|<Sample>` -> the universe entry
 * @param {Function} o.inOpenUI5  the membership oracle (overview-openui5.mjs)
 * @returns {object[]} the rows, ordered module -> control -> sample name
 */
export function buildApps({ ROOT, META, uniMap, inOpenUI5 }) {

// collect ported apps: control (entity), module (library), sample name, class,
// and the repo-relative path of the generated class (for the ABAP GitHub link)
const apps = [];
const DEV_LABEL = { IMPROVISED: 'IMPROVISED', POST_171: 'POST-1.71', LIVE_TEST: 'LIVE-TEST', DROPPED_171: '1.71', SUBSET_DATA: 'SUBSET', NOTE: 'NOTE' };
for (const mf of fs.readdirSync(META)) {
  if (!mf.endsWith('.json')) continue;
  const m = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8'));
  const i = m.sample.indexOf('.sample.');
  if (i === -1) continue;
  const module = m.sample.slice(0, i);
  const name = m.sample.slice(i + '.sample.'.length);
  const u = uniMap.get(`${module}|${name}`) || {};
  const dep = u.deprecated || null;
  // the rating (1-5) is computed further down, once the audit flags are known.
  const devs = m.deviations || [];
  const nImpr = devs.filter((d) => d.type === 'IMPROVISED').length;
  const nDrop = devs.filter((d) => d.type === 'DROPPED_171').length;
  const nSub = devs.filter((d) => d.type === 'SUBSET_DATA').length;
  const nNote = devs.filter((d) => d.type === 'NOTE').length;
  const nLive = devs.filter((d) => d.type === 'LIVE_TEST').length;
  // the "Since" column shows the CONTROL's own since (next to Control). The
  // sample's required release is no longer a column of its own (dropped
  // 2026-07-29) but is still computed here: it drives the is_post171 flag behind
  // the Hide-newer-than-1.71 filter. It = the control since raised by any
  // post-1.71 member the port keeps (POST_171 deviations note "since X.YZ").
  const since = u.since || '';
  let release = since;
  // the highest version mentioned across ALL the port's POST_171 deviation texts
  // (every kept newer-than-1.71 member notes its @since). Take every X.Y(.Z)
  // token, not just "since X.Y" - the texts phrase it many ways
  // ("since UI5 1.84", "(since 1.97)", ">= 1.74", "OneByOne / TwoByOne (1.71)").
  for (const d of devs.filter((x) => x.type === 'POST_171')) {
    for (const mm of d.what.matchAll(/\b(\d+\.\d+(?:\.\d+)?)\b/g)) release = verMax(release, mm[1]);
  }
  // a since value is coloured orange when it is newer than UI5 1.71
  const overOneSeven = (v) => v !== '' && verCmp(v, '1.71') > 0;
  const ui5Only = !inOpenUI5(m.entity);
  const isDeprecated = !!dep;
  // "newer than 1.71 (2020)": the sample needs a release above 1.71 - either a
  // parsed release > 1.71, or (by definition) any kept POST_171 member, even when
  // its deviation text carries no explicit "since X.YZ"
  const nP171 = devs.filter((d) => d.type === 'POST_171').length;
  const isPost171 = nP171 > 0 || overOneSeven(release);
  // audit flags - which framework wiring the port actually uses, read straight
  // from its ABAP source. They no longer have a column of their own (the Audit
  // column was dropped 2026-07-29); they feed the Rating's test-priority term.
  // follow_up_action t_arg is detected as a t_arg keyword before
  // the call's first ")" (val/view args carry no ")", so this is reliable here).
  // "literal binding" = a binding path written by name in clear text ({FIELD} or
  // {/Path}, or a path:'name' inside a { } template) instead of via client->_bind,
  // which is what breaks on a variable rename.
  const srcPath = path.join(ROOT, m.file);
  const src = fs.existsSync(srcPath) ? fs.readFileSync(srcPath, 'utf8') : '';
  const srcNoBind = src.replace(/\{\s*client->_bind[\s\S]*?\}/g, '');
  const useEc      = /_event_client\s*\(/.test(src);
  const useEcArg   = /_event_client\s*\([^)]*\bt_arg\b/.test(src);
  const useFua     = /follow_up_action\s*\(/.test(src);
  const useFuaArg  = /follow_up_action\s*\([^)]*\bt_arg\b/.test(src);
  const usePopup   = /popup_display\s*\(/.test(src);
  const usePopover = /popover_display\s*\(/.test(src);
  const useName    = /\{[A-Z][A-Z0-9_]*\}/.test(src)
                  || /\{\/[A-Za-z]/.test(src)
                  || /\bpath\s*:\s*'[A-Za-z/]/.test(srcNoBind);

  // rating (1-5): a "by feel" score for how much attention a port deserves -
  // NOT a strict deviation count. Four things push it up (all additive):
  //   * complexity    - a big view / rich interaction is simply more to get right
  //   * rework        - every non-1:1 substitution (IMPROVISED / DROPPED_171 /
  //                     SUBSET_DATA) or documented subtlety (NOTE) is something
  //                     we had to correct or reason about
  //   * discussed     - a port we reviewed together (it carries a `checked` block)
  //                     earned a closer look, so it weighs a little more
  //   * test-priority - pending LIVE_TESTs, roundtrip-free/runtime-only wiring,
  //                     popups/popovers and a needs-newer-than-1.71 render are all
  //                     reasons to re-verify it in a running system
  // A faithful, simple, untouched static port stays at 1; a large, reworked,
  // much-discussed, live-test-pending port reaches 5. Sort descending to surface
  // the ports worth a closer manual look. Kept in sync with STATUS.md / AGENTS.md.
  const loc = src ? src.split('\n').length : 0;
  const nInteract = (src.match(/_event(_client)?\s*\(|follow_up_action\s*\(/g) || []).length;
  const nControls = (src.match(/->\s*(ele|tag)\s*\(/g) || []).length;
  const discussed = !!m.checked;
  const cxComplexity =
      (loc > 220 ? 1 : loc > 120 ? 0.6 : loc > 60 ? 0.3 : 0) +
      (nInteract >= 8 ? 0.7 : nInteract >= 3 ? 0.4 : nInteract >= 1 ? 0.2 : 0) +
      (nControls > 45 ? 0.3 : 0);
  const cxRework = 1.0 * nImpr + 1.0 * nDrop + 0.5 * nSub + 0.3 * nNote;
  const cxDiscussed = discussed ? 0.5 : 0;
  const cxTest =
      0.6 * nLive +
      ((useEc || useFua) ? 0.4 : 0) +
      ((usePopup || usePopover) ? 0.3 : 0) +
      (isPost171 ? 0.3 : 0);
  const rawScore = cxComplexity + cxRework + cxDiscussed + cxTest;
  const score = Math.min(5, Math.max(1, Math.round(1 + rawScore)));
  const scoreDrivers = [];
  if (cxComplexity >= 0.5) scoreDrivers.push('complex');
  if (cxRework >= 1) scoreDrivers.push(`${nImpr + nDrop + nSub} reworked`);
  else if (nNote) scoreDrivers.push(`${nNote} noted`);
  if (discussed) scoreDrivers.push('reviewed');
  if (cxTest >= 0.6) scoreDrivers.push('live-test');
  const scoreTip = `Rating ${score} of 5 - how much attention this port deserves ` +
    `(complexity + rework + review + test-priority${scoreDrivers.length ? ': ' + scoreDrivers.join(', ') : ''}). ` +
    `1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`;

  apps.push({
    module,
    control: m.entity,
    name,
    cls: m.class,
    file: m.file,
    checked: m.checked ? `CHECKED (${m.checked.date}): ${m.checked.note}` : '',
    notes: (m.deviations || []).map((d) => `${DEV_LABEL[d.type] ?? d.type}: ${d.what}`).join(' // '),
    post171: (m.deviations || []).filter((d) => d.type === 'POST_171').map((d) => d.what).join(' // '),
    since,
    since_post171: overOneSeven(since),
    dep_text: dep ? `Deprecated since ${dep.since}: ${dep.text}` : '',
    score,
    score_tip: scoreTip,
    ui5_only: ui5Only,
    is_post171: isPost171,
    is_deprecated: isDeprecated,
  });
}
// order by module, then control, then sample name (case-insensitive)
apps.sort((a, b) =>
  a.module.toLowerCase().localeCompare(b.module.toLowerCase()) ||
  a.control.toLowerCase().localeCompare(b.control.toLowerCase()) ||
  a.name.toLowerCase().localeCompare(b.name.toLowerCase()));

return apps;
}
