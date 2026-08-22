/*
 * ui5-libs — which UI5 library a control ships in.
 *
 * Shared by generate-search-index.mjs (the Pages catalogue) and
 * generate-catalogue.mjs (the committed machine-readable index), so the two
 * cannot disagree about a port's library. Factored out of the search-index
 * generator, where the comments below were written.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..');

/** The committed sample universe — every demo kit sample of the focused
 *  OpenUI5 libraries, with the release the snapshot was taken from. */
export const universe = JSON.parse(fs.readFileSync(path.join(ROOT, 'ui5', 'universe.json'), 'utf8'));

/* Every UI5 library a control in this corpus can come from. A control name is
 * mapped to its library by LONGEST prefix, because the namespace is not the
 * library: sap.ui.layout.form.SimpleForm ships in sap.ui.layout, and
 * sap.ui.model.type.Date in sap.ui.core. The OpenUI5 ones are read from
 * ui5/universe.json so a new library in the snapshot needs no edit here; the
 * SAPUI5-only ones (src/03) are listed, because no snapshot in this
 * repository covers them. */
const EXTRA_LIBS = [
  /* SAPUI5-only — the src/03 collection */
  'sap.ui.comp', 'sap.suite.ui.commons', 'sap.suite.ui.microchart',
  'sap.ui.vk', 'sap.ui.vbm', 'sap.viz', 'sap.gantt', 'sap.ndc',
  'sap.ushell', 'sap.collaboration', 'sap.ui.generic',
  /* OpenUI5 libraries no sample in ui5/universe.json is filed under */
  'sap.ui.webc.main', 'sap.ui.webc.fiori',
];
export const KNOWN_LIBS = [...new Set([...universe.libs.map((l) => l.lib), ...EXTRA_LIBS])]
  .sort((a, b) => b.length - a.length);

/** The library a control ships in.
 *
 *  Longest known prefix wins, because the namespace is not the library. The
 *  fallback matters as much as the match: everything under `sap.ui.` that is
 *  not a library of its own SHIPS IN sap.ui.core — `sap.ui.model.type.Date`
 *  and `sap.ui.base.Object` have no library called `sap.ui.model` or
 *  `sap.ui.base` behind them, and offering one as a filter would invite a
 *  reader to look for a library that does not exist.
 */
export const libraryOf = (control) => KNOWN_LIBS.find((lib) => control === lib || control.startsWith(`${lib}.`))
  || (control.startsWith('sap.ui.') ? 'sap.ui.core' : control.split('.').slice(0, -1).join('.'));

/* The library facet for a class with no sidecar — the SAPUI5 collection under
 * src/03, whose controls no snapshot in this repository resolves. Its DESCRIPT
 * names the library itself ("sap.suite.ui.commons - Timeline"), which is the
 * answer; the fallback drops sap.ui.core and sap.m, because every view builds
 * something from both and neither is what the port is about. */
export function descriptLibrary(descript, libs) {
  const head = descript.split(' - ')[0].trim();
  if (KNOWN_LIBS.includes(head)) return head;
  return libs.find((l) => l !== 'sap.ui.core' && l !== 'sap.m') || libs[0] || '';
}
