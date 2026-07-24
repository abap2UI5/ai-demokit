// Copy the webpacked static site (build/) into ../docs, the folder GitHub
// Pages serves. Drops the .map (not needed for the demo) and keeps a
// .nojekyll so Pages serves the underscore-prefixed assets verbatim.
import { cpSync, existsSync, writeFileSync, readdirSync, rmSync } from "node:fs";
import { join } from "node:path";
const BUILD = new URL("../build", import.meta.url).pathname;
const DOCS = new URL("../../docs", import.meta.url).pathname;
if (!existsSync(BUILD)) throw new Error("build/ not found - run `npm run webpack:build` first");
if (existsSync(DOCS)) for (const f of readdirSync(DOCS)) rmSync(join(DOCS, f), { recursive: true, force: true });
cpSync(BUILD, DOCS, { recursive: true, filter: (src) => !src.endsWith(".map") });
writeFileSync(join(DOCS, ".nojekyll"), "");
console.log("copied build/ -> docs/ (Pages source)");
