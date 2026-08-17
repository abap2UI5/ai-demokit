/* Directories under `src/` that are on disk but are not this repository.
 *
 * `src/zz_dev` is where abap2UI5/ai-mcp's `deploy_app` writes the class an
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
