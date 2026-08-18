/* The class DESCRIPT, read the way an abapGit sidecar actually stores it.
 *
 * `<DESCRIPT>` is XML, so a description containing an apostrophe is on disk as
 *
 *   <DESCRIPT>sap.m.FacetFilter - This is a &apos;Light&apos; version of the F</DESCRIPT>
 *
 * Two generators read that field, both with a bare `match(/<DESCRIPT>…/)` and
 * neither unescaping, so `&apos;Light&apos;` reached the generated `@keywords`
 * line of z2ui5_cl_smpc_app_022 as the single token `aposlightapos` — the
 * search term `light` did not find the port that is ABOUT the light version.
 * Silent, because a keyword line is generated and never read by a person.
 *
 * abap2UI5/samples and abap2UI5/samples-stack both unescape; this repository
 * was the one that did not. It is one function rather than one per generator
 * for the obvious reason: the bug was in the copy, not in the idea.
 */
import fs from 'fs';

/* The five predefined XML entities. `&amp;` goes LAST, so that an escaped
 * `&amp;apos;` becomes the literal text `&apos;` rather than an apostrophe. */
export const unescapeXml = (s) => s
  .replace(/&lt;/g, '<')
  .replace(/&gt;/g, '>')
  .replace(/&quot;/g, '"')
  .replace(/&apos;/g, "'")
  .replace(/&amp;/g, '&');

/** The DESCRIPT of the class whose source file is `abapFile`, or `''`.
 *
 *  Takes the .clas.abap path and finds its sidecar, because that is what both
 *  callers have in hand while walking `src/`.
 */
export function readDescript(abapFile) {
  const xml = abapFile.replace(/\.clas\.abap$/, '.clas.xml');
  if (!fs.existsSync(xml)) return '';
  const found = fs.readFileSync(xml, 'utf8').match(/<DESCRIPT>([^<]*)<\/DESCRIPT>/);
  return found ? unescapeXml(found[1]) : '';
}
