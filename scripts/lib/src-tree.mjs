import fs from 'fs';
import path from 'path';

/* Directories under `src/` that are on disk but are not this repository.
 *
 * `src/zz_dev` is where abap2UI5/mcp-server's `deploy_app` writes the class an
 * agent is working on: it is in `.gitignore`, it is scratch, and it is the
 * documented way an agent gets an app onto the transpiled backend to run and
 * screenshot it.
 *
 * Every script here walks `src/` on the filesystem, and the filesystem does not
 * read `.gitignore`. So the loop this ecosystem recommends to agents —
 * deploy_app, build_backend, run_app — left four scratch classes where the
 * gates look, and `npm run gates` then failed on them:
 *
 *   ERROR src/zz_dev/ycl_app.clas.xml:1 [abapgit-xml-bom] file does not start
 *         with the UTF-8 BOM
 *
 * Four errors about files that are not in the repository and never will be.
 * The same walk put them in SAMPLES.md as an "MCP dev app" section and wrote
 * `" @keywords` lines into them. An agent following the documented loop got a
 * red run caused entirely by its own scratch, which is the worst possible
 * answer: it is not wrong about anything, and it is not obviously noise either.
 *
 * One list, imported by every walker, so that the next scratch location is
 * declared once rather than found four gates later.
 */

/** Directory NAMES (not paths) skipped anywhere under `src/`. */
export const SKIPPED_DIRS = new Set(['zz_dev']);

/** True when a directory entry must not be walked into. */
export const isSkippedDir = (name) => SKIPPED_DIRS.has(name);

/**
 * Every file under `dir`, recursively, in a DETERMINISTIC order, skipping the
 * directories above.
 *
 * The walk itself was written eleven times - byte-identical in
 * generate-samples-md, generate-catalogue, generate-search-index and
 * generate-screenshots, and with small differences everywhere else. Two of
 * those copies (generate-keywords, generate-summary) had lost the `.sort()`,
 * so the two `--check` gates built on them walked the corpus in whatever order
 * the filesystem answered in: the verdict was the same, but the order a
 * failure is reported in - and which failure a fail-fast run shows first -
 * depended on the machine. The header above already says why that is the wrong
 * shape ("One list, imported by every walker, so that the next scratch
 * location is declared once rather than found four gates later"); the walk is
 * the other half of that list.
 *
 * Sorting is not optional here. This repository regenerates six artefacts and
 * diffs them as a gate, and a generator emitting in filesystem order produces
 * a diff nobody can review.
 *
 * @param {string} dir   directory to walk (must exist)
 * @param {string} [ext] keep only files whose path ends with this
 * @returns {string[]}   absolute paths, parents before children, sorted
 */
export function walkFiles(dir, ext) {
  const out = [];
  const visit = (at) => {
    for (const name of fs.readdirSync(at).sort()) {
      if (isSkippedDir(name)) continue;
      const full = path.join(at, name);
      if (fs.statSync(full).isDirectory()) visit(full);
      else if (!ext || full.endsWith(ext)) out.push(full);
    }
  };
  visit(dir);
  return out;
}
