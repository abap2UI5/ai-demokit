#!/usr/bin/env node
/*
 * Port scaffolder — turn an OpenUI5 demo-kit sample into a ready-to-fill port
 * skeleton, so the mechanical boilerplate (template archive, batch folder,
 * package, class stub, clas.xml, meta sidecar, next app number, lib→folder) is
 * done for you and only the view rebuild remains.
 *
 *   node scripts/scaffold.mjs <sample> [options]
 *
 *   <sample>   sap.ui.table.sample.RowModes   (full id)
 *              sap.ui.table/RowModes          (lib/name)
 *              RowModes                        (bare name — looked up in universe.json)
 *
 *   --batch <bNN>   target an explicit batch folder
 *   --new-batch     create the next batch folder in the library
 *   --dry-run       print what would be created, write nothing
 *
 * Leaves the view as a TODO placeholder: structural_diff will (correctly) fail
 * until you rebuild ui5/<lib>/<Name>/*.view.xml 1:1 in view_display. When the
 * sample loads a JSON mock, the scaffolder prints the json-to-abap command to
 * inline that data.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const SRC = path.join(ROOT, 'src');
const UI5 = path.join(ROOT, 'ui5');

const argv = process.argv.slice(2);
const flags = { };
const positional = [];
for (let i = 0; i < argv.length; i++) {
  const a = argv[i];
  if (a === '--batch') flags.batch = argv[++i];
  else if (a === '--new-batch') flags.newBatch = true;
  else if (a === '--dry-run') flags.dryRun = true;
  else positional.push(a);
}
const input = positional[0];
if (!input) {
  console.error('usage: node scripts/scaffold.mjs <sample> [--batch bNN | --new-batch] [--dry-run]');
  process.exit(2);
}

// ---------- resolve the sample -> { lib, name, entity } ----------
const universe = JSON.parse(fs.readFileSync(path.join(UI5, 'universe.json'), 'utf8'));
function lookupUniverse(name, lib) {
  for (const l of universe.libs) {
    if (lib && l.lib !== lib) continue;
    const s = l.samples.find((s) => s.name.toLowerCase() === name.toLowerCase());
    if (s) return { lib: l.lib, name: s.name, entity: s.entity };
  }
  return null;
}
function resolveSample(str) {
  let lib, name;
  if (str.includes('.sample.')) { lib = str.slice(0, str.indexOf('.sample.')); name = str.slice(str.indexOf('.sample.') + '.sample.'.length); }
  else if (str.includes('/')) { [lib, name] = str.split('/'); }
  else { name = str; }
  const u = lookupUniverse(name, lib);
  if (u) return u;
  if (lib) return { lib, name, entity: `${lib}.${name}` }; // explicit lib, not in universe
  // bare name, not found — collect candidates for a helpful error
  const cands = [];
  for (const l of universe.libs) for (const s of l.samples) if (s.name.toLowerCase() === name.toLowerCase()) cands.push(`${l.lib}/${s.name}`);
  if (cands.length) { console.error(`ambiguous "${name}" — qualify with a lib:\n  ${cands.join('\n  ')}`); process.exit(1); }
  console.error(`sample "${name}" not found in ui5/universe.json — pass a qualified <lib>/<name>`); process.exit(1);
}
const { lib, name, entity } = resolveSample(input);

// ---------- lib -> src folder ----------
function srcFolder(lib) {
  if (lib === 'sap.m') return '01';
  if (lib.startsWith('sap.ui')) return '02';
  if (lib === 'sap.uxap') return '03';
  if (lib === 'sap.f') return '04';
  if (lib === 'sap.tnt') return '05';
  return null;
}
const folder = srcFolder(lib);
if (!folder) { console.error(`no src/ folder mapping for library "${lib}" (known: sap.m, sap.ui.*, sap.uxap, sap.f, sap.tnt)`); process.exit(1); }

// ---------- locate the OpenUI5 template dir ----------
const libPath = lib.replace(/\./g, '/');
const SRC_ROOTS = [process.env.OPENUI5_SRC, '/home/user/fork-openui5', path.join(ROOT, 'openui5'), path.join(ROOT, '..', 'fork-openui5')].filter(Boolean);
let templateDir = null;
for (const r of SRC_ROOTS) {
  const cand = path.join(r, 'src', lib, 'test', libPath, 'demokit', 'sample', name);
  if (fs.existsSync(cand)) { templateDir = cand; break; }
}
if (!templateDir) {
  console.error(`template not found for ${lib}/${name}. Looked under:\n  ${SRC_ROOTS.map((r) => path.join(r, 'src', lib, 'test', libPath, 'demokit', 'sample', name)).join('\n  ')}\nSet OPENUI5_SRC to your OpenUI5 checkout.`);
  process.exit(1);
}

// ---------- next app number ----------
let maxNum = 0;
for (const f of fs.readdirSync(META)) { const m = f.match(/app_(\d+)\.json$/); if (m) maxNum = Math.max(maxNum, +m[1]); }
const num = String(maxNum + 1).padStart(3, '0');
const cls = `z2ui5_cl_ai_app_${num}`;

// ---------- batch folder ----------
const libDir = path.join(SRC, folder);
const existingBatches = fs.existsSync(libDir) ? fs.readdirSync(libDir).filter((d) => /^b\d+$/.test(d)).sort() : [];
let batch;
if (flags.batch) batch = flags.batch;
else if (flags.newBatch || !existingBatches.length) {
  const maxB = existingBatches.length ? Math.max(...existingBatches.map((b) => +b.slice(1))) : 0;
  batch = `b${String(maxB + 1).padStart(2, '0')}`;
} else batch = existingBatches[existingBatches.length - 1];
const batchDir = path.join(libDir, batch);
const relFile = `src/${folder}/${batch}/${cls}.clas.abap`;

// ---------- build artifacts ----------
const DEVC = `﻿<?xml version="1.0" encoding="utf-8"?>
<abapGit version="v1.0.0" serializer="LCL_OBJECT_DEVC" serializer_version="v1.0.0">
 <asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
  <asx:values>
   <DEVC>
    <CTEXT>faithful ports</CTEXT>
   </DEVC>
  </asx:values>
 </asx:abap>
</abapGit>
`;
const clasAbap = `CLASS ${cls} DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS ${cls} IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " TODO rebuild ui5/${lib}/${name}/*.view.xml 1:1 here (${entity})
    view->open( n = \`View\` ns = \`mvc\`
        )->a( n = \`xmlns\`     v = \`sap.m\`
        )->a( n = \`xmlns:mvc\` v = \`sap.ui.core.mvc\`
        )->a( n = \`height\`    v = \`100%\`

        )->open( \`Page\`
            )->a( n = \`title\` v = \`${name}\`

            )->leaf( \`Text\`
                )->a( n = \`text\` v = \`TODO: port ${lib}.sample.${name}\` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " TODO seed the default model (see the sample's controller / JSON mock)
    RETURN.

  ENDMETHOD.

ENDCLASS.
`;
const clasXml = `﻿<?xml version="1.0" encoding="utf-8"?>
<abapGit version="v1.0.0" serializer="LCL_OBJECT_CLAS" serializer_version="v1.0.0">
 <asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
  <asx:values>
   <VSEOCLASS>
    <CLSNAME>${cls.toUpperCase()}</CLSNAME>
    <LANGU>E</LANGU>
    <DESCRIPT>${lib} - ${name}</DESCRIPT>
    <STATE>1</STATE>
    <CLSCCINCL>X</CLSCCINCL>
    <FIXPT>X</FIXPT>
    <UNICODE>X</UNICODE>
   </VSEOCLASS>
  </asx:values>
 </asx:abap>
</abapGit>
`;
const meta = {
  class: cls,
  sample: `${lib}.sample.${name}`,
  entity,
  file: relFile,
  batch,
  audit: { frontend_action: false, event_t_arg: false },
  status: 'generated',
  checked: null,
  deviations: [],
};

// ---------- copy template files (recursive) ----------
function collect(dir, base = dir, out = []) {
  for (const n of fs.readdirSync(dir)) {
    const full = path.join(dir, n);
    if (fs.statSync(full).isDirectory()) collect(full, base, out);
    else out.push(path.relative(base, full));
  }
  return out;
}
const templateFiles = collect(templateDir);
const ui5Dest = path.join(UI5, lib, name);

// ---------- detect a JSON mock the controller loads (hint for #6) ----------
let mockHint = null;
const controllerFile = templateFiles.find((f) => /Controller\.controller\.js$/.test(f));
if (controllerFile) {
  const ctrl = fs.readFileSync(path.join(templateDir, controllerFile), 'utf8');
  const mockMatch = ctrl.match(/toUrl\(\s*["']([^"']*\.json)["']/) || ctrl.match(/["']([\w./-]*mock[\w./-]*\.json)["']/i);
  if (mockMatch) mockHint = mockMatch[1];
}

// ---------- guard against clobbering ----------
const targetAbap = path.join(ROOT, relFile);
if (fs.existsSync(targetAbap)) { console.error(`refusing to overwrite existing ${relFile}`); process.exit(1); }

// ---------- summary ----------
const created = [
  relFile,
  `src/${folder}/${batch}/${cls}.clas.xml`,
  `meta/${cls}.json`,
  ...(fs.existsSync(path.join(batchDir, 'package.devc.xml')) ? [] : [`src/${folder}/${batch}/package.devc.xml`]),
  ...templateFiles.map((f) => `ui5/${lib}/${name}/${f}`),
];
console.log(`scaffold ${cls}  (${lib}.sample.${name} — ${entity})`);
console.log(`  library src/${folder}  batch ${batch}${existingBatches.includes(batch) ? '' : ' (new)'}`);
console.log(`  template: ${path.relative(ROOT, templateDir)}`);
console.log('  files:');
for (const f of created) console.log(`    + ${f}`);

if (flags.dryRun) { console.log('\n(dry-run — nothing written)'); process.exit(0); }

// ---------- write ----------
fs.mkdirSync(batchDir, { recursive: true });
if (!fs.existsSync(path.join(batchDir, 'package.devc.xml'))) fs.writeFileSync(path.join(batchDir, 'package.devc.xml'), DEVC);
fs.writeFileSync(targetAbap, clasAbap);
fs.writeFileSync(path.join(ROOT, `src/${folder}/${batch}/${cls}.clas.xml`), clasXml);
fs.writeFileSync(path.join(META, `${cls}.json`), JSON.stringify(meta, null, 2) + '\n');
fs.mkdirSync(ui5Dest, { recursive: true });
for (const rel of templateFiles) {
  const dst = path.join(ui5Dest, rel);
  fs.mkdirSync(path.dirname(dst), { recursive: true });
  fs.copyFileSync(path.join(templateDir, rel), dst);
}

console.log(`\nnext steps:`);
console.log(`  1. rebuild the view in ${relFile} (view_display) to match ui5/${lib}/${name}/`);
console.log(`  2. seed model_init; then run the fast gates`);
if (mockHint) {
  console.log(`  data: this sample loads ${mockHint} — inline it with:`);
  console.log(`        node scripts/json-to-abap.mjs <path-to>/${path.basename(mockHint)} --path <ArrayKey> --var <field>`);
}
