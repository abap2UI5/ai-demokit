#!/usr/bin/env node
/*
 * IMPROVISED harvest (STATUS.md open findings, 2026-08-05)
 *
 * Every `IMPROVISED` deviation in `meta/` is a place where the port does
 * something the original sample does not. That set is the repo's raw material
 * for its actual purpose - "expose the functional gaps so they can be closed" -
 * but only a fraction of it IS a framework gap: most entries are a POLICY the
 * corpus decided on (thin frontend, one default model, data flattening), a
 * documented capability BOUNDARY, or a port that needs REWORK against a
 * capability that already exists.
 *
 * This probe sorts every IMPROVISED entry into one of those verdicts, so the
 * gap harvest is repeatable instead of a one-off read of 136 sidecar texts:
 *
 *   GAP      -> a framework gap, filed under pr/<folder> (named in the family)
 *   PROBE    -> a suspected gap whose premise is UNVERIFIED; measure before filing
 *   REWORK   -> expressible today; the port under-delivers (review backlog)
 *   BOUNDARY -> outside abap2UI5 by nature (client-only APIs, sample-local JS)
 *   POLICY   -> a decided corpus rule; the deviation is the rule working
 *
 * The first matching family wins, so the ordering below is the classification:
 * review verdicts ("needs rework", "refuted") are matched BEFORE the topical
 * families, otherwise a flagged port would hide inside its own topic.
 *
 * Run:  node scripts/probes/improvised-cluster.mjs [--strict] [--family <key>] [--json]
 *       node scripts/probes/improvised-cluster.mjs --retype-policy [--write]
 *
 * --retype-policy proposes the POLICY entries for retyping to NOTE. IMPROVISED
 * means "a behaviour of the original is lost or substituted" (that is why the
 * 2026-07-27 review retyped app 108 the other way, from NOTE to IMPROVISED);
 * a decided corpus rule that renders identically is a NOTE. Entries whose text
 * still NAMES a loss are held back and listed - a family verdict does not
 * override what the sidecar says about its own port.
 *
 * --strict exits 1 when a deviation matches no family. That is the ratchet:
 * a new port whose improvisation is a NEW shape has to be classified here (and
 * so, consciously, judged gap-or-not) instead of silently joining the pile.
 * It is deliberately NOT part of `npm run gates` - classifying is a reviewer's
 * call, not a generation-time one.
 */
import fs from 'fs';
import path from 'path';

const META = 'meta';

// ordered: first match wins
const FAMILIES = [
  // --- review verdicts first: these ports are already judged --------------
  {
    key: 'flagged-rework',
    verdict: 'REWORK',
    label: 'review flagged the improvisation as under-delivering (rework before promotion)',
    re: /needs rework|flagged for rework|open rework before promotion|is (?:WRONG|wrong)|is refuted|are refuted|under-deliver/i,
  },
  {
    key: 'breadth-probe',
    verdict: 'REWORK',
    label: 'breadth-probe port: deliberately reduced rebuild, faithful rebuild still owed',
    re: /breadth-probe/i,
  },

  // --- framework gaps: filed under pr/ ------------------------------------
  {
    key: 'empty-vs-default',
    verdict: 'GAP',
    pr: 'model-empty-vs-default',
    label: 'an initial ABAP field serializes as "" and overrides the UI5 property default',
    re: /empty (?:ABAP )?model field|empty string is rejected|no empty string reaches|never emit an empty enum|binds? as ""|empty enum value|rows without \w+ carry an empty string/i,
  },
  {
    key: 'dom-style',
    verdict: 'GAP',
    pr: 'control-inline-style',
    label: 'the sample writes a CSS value onto a control\'s DOM node; no bindable property exists',
    re: /jQuery|\$\(\)\.width|straight onto (?:its|the) (?:rendered )?DOM node|DOM styling|raw DOM styling|getDomRef\(\)\.\w+/i,
  },
  {
    key: 'array-property',
    verdict: 'GAP',
    pr: 'table-set-sticky',
    label: 'an array-valued control property (Table.sticky) is neither bindable nor whitelisted',
    re: /setSticky|array-valued property/i,
  },
  {
    key: 'null-argument',
    verdict: 'GAP',
    pr: 'control-method-null-arg',
    label: 'a control method needs a null/empty argument (association reset); no arg kind carries one',
    re: /setSelectedSection|empty\/null association|is an ASSOCIATION/i,
  },
  {
    key: 'a11y-announce',
    verdict: 'GAP',
    pr: 'invisible-message-announce',
    label: 'sap.ui.core.InvisibleMessage is a singleton: no id to address, no CONTROL_GLOBAL target',
    re: /InvisibleMessage is a JS singleton/i,
  },
  {
    key: 'formatting-config',
    verdict: 'GAP',
    pr: 'custom-currency-formatting',
    label: 'a global UI5 formatting config (Formatting.setCustomCurrencies) has no wire',
    re: /setCustomCurrencies|global frontend i18n formatting config/i,
  },

  // --- ports that under-deliver against a capability that already ships ---
  {
    key: 'under-uses-capability',
    verdict: 'REWORK',
    label: 'a shipped capability (compound binding_call filter, open(searchValue), cc.MessageManager) is not used',
    re: /compound OR over two fields is simplified|pre-filter-on-open behaviour is lost|addMessages seed .* is not reproduced/i,
  },
  {
    key: 'static-toast-substitution',
    verdict: 'REWORK',
    label: 'a controller behaviour is substituted by a static toast that could carry its value',
    re: /each press raises a client MESSAGE_TOAST|STATIC-text client MESSAGE_TOAST|wired to simple toasts|here each press raises/i,
  },

  // --- suspected gaps whose premise is not measured yet -------------------
  {
    key: 'event-value-unreachable',
    verdict: 'PROBE',
    label: 'the value the original reads sits in an array / control reference on the event',
    re: /not transportable|control references are not transportable|carries no date parameter|array indexing|ARRAY OF DateRange|oldSizes|getSelectedDates|is control state|getMetadata\(\)\.getName\(\)|cannot branch|DateRange control reference|not a value that can be transported|selected day is not read|calendar focus is not moved/i,
  },
  {
    key: 'event-veto',
    verdict: 'PROBE',
    label: 'a conditional / per-item event veto (preventDefault) beyond the render-time flag',
    re: /preventDefault|event veto/i,
  },
  {
    key: 'imperative-aggregation',
    verdict: 'PROBE',
    label: 'imperative add/remove on a statically declared aggregation (bind it instead - app 085)',
    re: /addToken\/removeToken|dynamic addItem|is not mirrored|imperative control mutation over static/i,
  },
  {
    key: 'template-clone-id',
    verdict: 'PROBE',
    label: 'a control cloned from an aggregation template is not addressable by id',
    re: /aggregation-template CLONES|template-clone|index-based page resolution/i,
  },
  {
    key: 'window-resize-event',
    verdict: 'PROBE',
    label: 'no live window-resize / breakpoint wire: device metrics are read once per round-trip',
    re: /ResizeHandler|live recalculation on window resize/i,
  },
  {
    key: 'shortcut-scope',
    verdict: 'PROBE',
    label: 'the keyboard-shortcut registry is document-global; no popup-local command scope',
    re: /document-global|popover-local command scope/i,
  },

  // --- boundaries: not abap2UI5's to close --------------------------------
  {
    key: 'sample-local-js',
    verdict: 'BOUNDARY',
    label: 'the behaviour lives in a sample-local JS module or a browser-only API',
    re: /RevealGrid|sap\/ui\/core\/hyphenation|document\.styleSheets|styleSheets|sample-local (?:JS )?(?:helper )?module|sample-only JS helper|CSSColor\.isValid|not shipped in any UI5 library|demo-kit-internal/i,
  },
  {
    key: 'asset-not-shipped',
    verdict: 'BOUNDARY',
    label: 'the sample references an asset (CSS) it does not ship, so the effect cannot be reproduced',
    re: /not part of the sample's shipped files/i,
  },
  {
    key: 'odata-model',
    verdict: 'BOUNDARY',
    label: 'the sample runs on an OData/mock-server model; abap2UI5 feeds the model from ABAP instead',
    re: /OData|mock server/i,
  },
  {
    key: 'client-state',
    verdict: 'BOUNDARY',
    label: 'the original reads client-side state the thin backend cannot see',
    re: /client state the backend cannot read|isSideContentVisible|walks the client-side control tree|the thin backend cannot do|client-side control tree/i,
  },
  {
    key: 'i18n-fold',
    verdict: 'BOUNDARY',
    label: 'i18n> ResourceModel texts resolved server-side (ABAP owns translation; no runtime language switch)',
    re: /i18n/i,
  },
  {
    key: 'date-object-model',
    verdict: 'BOUNDARY',
    label: 'a JS Date object in the model is replaced by a string + source pattern (CAPABILITIES idiom)',
    re: /source (?:format[Oo]ption|pattern)|Date object|UI5Date\.getInstance|DateTimeOffset|locale-dependent client formatter|client-side clock/i,
  },

  // --- decided corpus policy ---------------------------------------------
  {
    key: 'blockbase-inline',
    verdict: 'POLICY',
    label: 'custom BlockBase blocks inlined to their view content (CAPABILITIES technique)',
    re: /BlockBase|ModelMapping/i,
  },
  {
    key: 'named-model-fold',
    verdict: 'POLICY',
    label: 'named JSON models folded into the single default model (pr/named-json-models, declined)',
    re: /named[- ](?:JSON )?models?|named model|one default model|single default model|serves ONE default model|\bimg>|\$cmd>|named-model fold/i,
  },
  {
    key: 'mock-flatten',
    verdict: 'POLICY',
    label: 'the shared demo kit mock is flattened / reduced to the bound columns',
    re: /flattened into the default model|unbound columns|ProductCollection|flatten|element-bind|only the single record|folded to flat fields|flat ABAP row/i,
  },
  {
    key: 'static-asset-fold',
    verdict: 'POLICY',
    label: 'a relative test-resources asset URL resolved to the absolute OpenUI5 host',
    re: /sdk\.openui5\.org|absolute .* URL|static (?:demo )?image/i,
  },
  {
    key: 'thin-frontend',
    verdict: 'POLICY',
    label: 'frontend formatter / imperative setter replaced by ABAP-computed data or a bound property',
    re: /two-way|expression binding|thin[- ]frontend|prefer a bindable property|business logic|computed in ABAP|expressed as bound properties|two-way bound?|bound two-way|precomputed|deterministic|formatter|validation messages|companion control/i,
  },
  {
    key: 'view-composition',
    verdict: 'POLICY',
    label: 'fragments / multiple views composed into the one port view, or a client-lazy load turned into a round-trip',
    re: /core:FragmentDefinition|Fragment\.load|core:Fragment|popover_display|popup_display|routing|round-trip where the original|no runtime Fragment reference|rebuilt inline|inlined 1:1 into the single port view|`dependents`|mvc:dependents/i,
  },
  {
    key: 'message-model-static',
    verdict: 'POLICY',
    label: 'a static message set is bound as a plain ABAP table instead of the message> model (endorsed path)',
    re: /static message set|no ABAP API to push an arbitrary/i,
  },
  {
    key: 'bound-instead-of-static',
    verdict: 'POLICY',
    label: 'static child controls of the original are rebuilt as a bound aggregation (or vice versa)',
    re: /now model-bound|bound Token template/i,
  },
  {
    key: 'resolved-literal',
    verdict: 'POLICY',
    label: 'a value the original computes from a client-only source is resolved to its literal result',
    re: /endpoint-independent|resolved literal/i,
  },
  {
    key: 'cosmetic-drop',
    verdict: 'POLICY',
    label: 'a purely cosmetic / inert attribute or wrapper is dropped',
    re: /cosmetics|layoutData|responsive-span|cosmetic|inert|no data\/behaviour|no app state depends on it|CustomData/i,
  },
];

const VERDICT_ORDER = ['GAP', 'PROBE', 'REWORK', 'BOUNDARY', 'POLICY'];

const args = process.argv.slice(2);
const strict = args.includes('--strict');
const asJson = args.includes('--json');
const retype = args.includes('--retype-policy');
const write = args.includes('--write');

/* A POLICY deviation whose text still names a lost behaviour is NOT a NOTE -
 * the family says how the port was built, this says what it costs. */
const LOSS = /\block\b|\blost\b|\bis lost\b|are lost\b|not reproduced|not reproducible|dropped entirely|no longer|is gone|are gone|cannot|is not wired|does nothing|unverified/i;
const only = args.includes('--family') ? args[args.indexOf('--family') + 1] : null;

const rows = [];
for (const f of fs.readdirSync(META).sort()) {
  if (!f.endsWith('.json')) continue;
  const m = JSON.parse(fs.readFileSync(path.join(META, f), 'utf8'));
  const port = f.replace('z2ui5_cl_ai_app_', '').replace('.json', '');
  for (const d of m.deviations || []) {
    if (d.type !== 'IMPROVISED') continue;
    const what = String(d.what || '').replace(/\s+/g, ' ');
    const fam = FAMILIES.find((x) => x.re.test(what)) || null;
    rows.push({ port, sample: m.sample, entity: m.entity, status: m.status, what, family: fam?.key ?? null });
  }
}

const byKey = new Map(FAMILIES.map((f) => [f.key, []]));
const unclassified = [];
for (const r of rows) (r.family ? byKey.get(r.family) : unclassified).push(r);

if (retype) {
  const policy = FAMILIES.filter((f) => f.verdict === 'POLICY').map((f) => f.key);
  const candidates = rows.filter((r) => policy.includes(r.family));
  const held = candidates.filter((r) => LOSS.test(r.what));
  const move = candidates.filter((r) => !LOSS.test(r.what));
  console.log(`POLICY deviations: ${candidates.length} - ${move.length} retype to NOTE, ${held.length} held back (their text names a loss)\n`);
  for (const r of held) console.log(`  HOLD ${r.port} [${r.family}] ${r.what.slice(0, 120)}…`);
  if (write) {
    const byPort = new Map();
    for (const r of move) byPort.set(r.port, (byPort.get(r.port) || 0) + 1);
    for (const [port] of byPort) {
      const file = path.join(META, `z2ui5_cl_ai_app_${port}.json`);
      const m = JSON.parse(fs.readFileSync(file, 'utf8'));
      for (const d of m.deviations) {
        if (d.type !== 'IMPROVISED') continue;
        const what = String(d.what).replace(/\s+/g, ' ');
        const fam = FAMILIES.find((x) => x.re.test(what));
        if (!fam || fam.verdict !== 'POLICY' || LOSS.test(what)) continue;
        d.type = 'NOTE';
      }
      fs.writeFileSync(file, `${JSON.stringify(m, null, 2)}\n`);
    }
    console.log(`\nwrote ${byPort.size} sidecar(s)`);
  } else {
    console.log('\n(dry run - pass --write to apply)');
  }
} else if (asJson) {
  console.log(JSON.stringify({ total: rows.length, rows, unclassified: unclassified.length }, null, 1));
} else if (only) {
  const fam = FAMILIES.find((f) => f.key === only);
  if (!fam) { console.error(`unknown family '${only}'`); process.exit(2); }
  console.log(`${fam.verdict}  ${fam.key} - ${fam.label}${fam.pr ? `\n  -> pr/${fam.pr}` : ''}\n`);
  for (const r of byKey.get(only)) console.log(`  ${r.port} [${r.status}] ${r.entity}\n    ${r.what}\n`);
} else {
  console.log(`IMPROVISED deviations: ${rows.length} across ${new Set(rows.map((r) => r.port)).size} ports\n`);
  for (const v of VERDICT_ORDER) {
    const fams = FAMILIES.filter((f) => f.verdict === v);
    const n = fams.reduce((a, f) => a + byKey.get(f.key).length, 0);
    console.log(`== ${v} (${n})`);
    for (const f of fams) {
      const hits = byKey.get(f.key);
      if (!hits.length) continue;
      const ports = [...new Set(hits.map((h) => h.port))];
      console.log(`   ${f.key.padEnd(24)} ${String(hits.length).padStart(3)}  ${f.pr ? `pr/${f.pr}` : ''}`);
      console.log(`   ${''.padEnd(24)}      ${f.label}`);
      console.log(`   ${''.padEnd(24)}      ports: ${ports.join(' ')}`);
    }
    console.log('');
  }
  if (unclassified.length) {
    console.log(`== UNCLASSIFIED (${unclassified.length}) - classify each in FAMILIES above`);
    for (const r of unclassified) console.log(`   ${r.port} [${r.status}] ${r.entity}\n     ${r.what}\n`);
  }
}

if (strict && unclassified.length) {
  console.error(`\nFAIL: ${unclassified.length} IMPROVISED deviation(s) match no family.`);
  process.exit(1);
}
