#!/usr/bin/env node
/*
 * faked-event-value audit (STATUS.md open findings, 2026-08-01)
 *
 * Finds ports whose toast/message text is a CONSTANT while the sample's own
 * controller composes it from event data (`MessageToast.show("… " + oEvent
 * .getParameter(…)…)`). That is the "faked event value" class: the port looks
 * right to every gate — structural-diff compares attribute names, the view-gates render gate
 * mocks the model — but the running app shows less than the original.
 *
 * A hit is NOT automatically a defect: a sample whose interaction is
 * deliberately dropped declares that as IMPROVISED (apps 118/203). Read the
 * sidecar before changing anything.
 *
 * It looks at TWO shapes, not one. The toast is the obvious one; the other is
 * an imperative write into a control -- setText/setValue/setTitle/setTooltip/
 * setDescription -- composed from event data. That second shape was the
 * probe's blind spot until 2026-08-21: app 141's original builds its status
 * line from oButton.getType() and oButton.getText() and writes it with
 * oText.setText(), the port wrote a constant, and this audit reported "0
 * candidates" the whole time because nothing there is a MessageToast.
 *
 * Run:  node scripts/probes/faked-event-value-audit.mjs
 */
import fs from 'fs'; import path from 'path';
const META='meta', UI5='ui5';
const walk=(d,o=[])=>{for(const n of fs.readdirSync(d)){const f=path.join(d,n);
 if(fs.statSync(f).isDirectory())walk(f,o); else o.push(f);} return o;};
const rows=[];
for (const f of fs.readdirSync(META)) {
  if (!f.endsWith('.json')) continue;
  const m = JSON.parse(fs.readFileSync(path.join(META,f),'utf8'));
  const cut = m.sample.indexOf('.sample.');
  if (cut === -1) continue;
  const lib = m.sample.slice(0, cut);
  const name = m.sample.slice(cut + '.sample.'.length);
  const dir = path.join(UI5, lib, name);
  if (!fs.existsSync(dir)) continue;
  const js = walk(dir).filter(p=>p.endsWith('.js')).map(p=>fs.readFileSync(p,'utf8')).join('\n');
  const abap = fs.existsSync(m.file) ? fs.readFileSync(m.file,'utf8') : '';
  // original composes a message from event data?
  const EVENTISH = /(getParameter|getSource|oEvent|evt|oItem|sId|getText|getTitle|getKey|getType)/;

  // Two shapes, and the second one needs CONTEXT rather than a call-site test.
  // A controller rarely composes the string where it uses it: app 141 builds
  // its status line from oButton.getType()/getText() inside one `var` chain and
  // writes it with oText.setText(...) two lines later, so a call-site-only
  // regex sees literals plus a variable and reports nothing - which is exactly
  // why this audit said "0 candidates" while app 141 showed a constant.
  // So a setter counts when it CONCATENATES and the code just above it reads
  // the event. Coarser than data flow, and deliberately so: a probe may
  // over-report (its own header says read the sidecar first), but it must not
  // stay blind to a whole shape.
  const NEARBY = 600;
  const concatenates = (t) => /\+|`|\$\{/.test(t);
  const dyn = [];
  for (const hit of js.matchAll(/MessageToast\.show\(([^;]{0,200})/g)) {
    if (concatenates(hit[1]) && EVENTISH.test(hit[1])) dyn.push(hit[1]);
  }
  for (const hit of js.matchAll(/\.(?:setText|setValue|setTitle|setTooltip|setDescription)\(([^;]{0,200})/g)) {
    const before = js.slice(Math.max(0, hit.index - NEARBY), hit.index);
    if (concatenates(hit[1]) && (EVENTISH.test(hit[1]) || EVENTISH.test(before))) dyn.push(hit[1]);
  }
  if (!dyn.length) continue;
  // port carries a composed value? (a {0} template, an $event/$parameters arg, or an ABAP | | template)
  // The port side has to be read as widely as the original side, or widening
  // one half just manufactures false positives: app 351 composes its resize
  // counter into a BOUND FIELD with an ABAP string template
  // (`eventstatus = |{ sy-datum ... } - Resize # { resizes }|`), which is
  // composing by any reasonable reading and was reported as faked until this
  // test grew the last alternative.
  const composed = /\{0\}|\$event|\$\{\$parameters|\$\{\$source|message_toast_display\( \|/.test(abap)
                || /get_event_arg\(/.test(abap)
                || /=\s*\|[^|\n]*\{[^}\n]*\}[^|\n]*\|/.test(abap);
  if (!composed) rows.push([m.class.slice(-3), m.status, m.sample, dyn[0].replace(/\s+/g,' ').slice(0,90)]);
}
rows.sort();
console.log('candidates:', rows.length);
for (const r of rows) console.log(r[0], '['+r[1]+']', r[2], '\n     original:', r[3]);
