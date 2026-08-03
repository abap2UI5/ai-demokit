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
  const dyn = [...js.matchAll(/MessageToast\.show\(([^;]{0,200})/g)].map(x=>x[1])
    .filter(t => /\+|`|\$\{/.test(t) && /(getParameter|getSource|oEvent|evt|oItem|sId|getText|getTitle|getKey)/.test(t));
  if (!dyn.length) continue;
  // port carries a composed value? (a {0} template, an $event/$parameters arg, or an ABAP | | template)
  const composed = /\{0\}|\$event|\$\{\$parameters|\$\{\$source|message_toast_display\( \|/.test(abap)
                || /get_event_arg\(/.test(abap);
  if (!composed) rows.push([m.class.slice(-3), m.status, m.sample, dyn[0].replace(/\s+/g,' ').slice(0,90)]);
}
rows.sort();
console.log('candidates:', rows.length);
for (const r of rows) console.log(r[0], '['+r[1]+']', r[2], '\n     original:', r[3]);
