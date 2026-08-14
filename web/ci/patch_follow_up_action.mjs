// Pre-transpile patch: rewrite the VIEW-WIRED `follow_up_action( )` calls to
// `_event_client( )` in the build COPY of the sources.
//
// Runs against the copied ABAP tree the transpiled builds stand on — the
// browser build's `src/ai-demokit`, the Node e2e backend's `node/downport` —
// before `abap_transpile` reads it. The committed corpus is never touched:
// it is correct ABAP and needs no fix on a real server.
//
// Why: `follow_up_action( )` is two calls in one, and it tells them apart by
// whether its own return value is consumed:
//
//     METHOD z2ui5_if_client~follow_up_action.
//       ...
//       IF result IS SUPPLIED.                      "  v = client->follow_up_action( … )
//         result = mo_srv_event->get_event_client( … ).   "  -> the roundtrip-free wire
//         RETURN.
//       ENDIF.
//       mo_action_front->queue_app_event( … ).      "  client->follow_up_action( … ).
//     ENDMETHOD.
//
// On a real ABAP server that is exactly right: for a RETURNING parameter,
// `IS SUPPLIED` is true when the method is called functionally. The
// transpiler does not model that. It compiles the predicate to
//
//     if ((INPUT && INPUT.result)) { … }
//
// and emits the SAME call shape for both forms — `await this.follow_up_action(
// {val: …, t_arg: …})`, with no `result` key in either — so `INPUT.result` is
// undefined and the wired branch is dead code. Verified against the pinned
// transpiler (@abaplint/transpiler-cli 2.13.40) and the newest published
// (2.13.59); both emit it identically.
//
// The effect is that every handler WIRED IN A VIEW comes out as the empty
// string: the control reaches the browser with no handler at all (app 049's
// e2e says it literally — "no StepInput carries a change handler"), and the
// press/change/select never fires. 26 ports regressed in the nightly the day
// the corpus renamed its `_event_client( )` wires to `follow_up_action( )`,
// and the GitHub Pages demo carries the same breakage.
//
// `_event_client( )` is the same wire with no second role — the framework's
// own interface documentation calls it "the identical roundtrip-free wire,
// byte for byte" — so it has nothing to detect and transpiles correctly. The
// patch therefore swaps ONLY the consumed form and leaves the 129 statement
// calls alone; those queue an action and work either way.
//
// Filed upstream as pr/transpiler-returning-is-supplied. When the transpiler
// passes the returning slot in INPUT: delete this file, its two call sites
// (web/package.json assemble, scripts/e2e-build.mjs) and the pr/ folder.
import { readFileSync, writeFileSync, existsSync, readdirSync, statSync } from "node:fs";
import { join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

// The consumed form comes in two shapes. On one line: `… v =
// client->follow_up_action( … )`. And as a `&&`-chained continuation, where
// the call starts its own line right after a line ending in `&&` (two client
// actions chained with `; ` — apps 076, 077 and 165). Verified exhaustively
// over the corpus — 430 same-line consumed, 25 chained continuations, 104
// statement calls, and the only other occurrences are prose inside the
// overview app's generated notes, which match neither shape.
const WIRED = /(=[ \t]*)client->follow_up_action\(/g;
const CONTINUED = /^([ \t]*)client->follow_up_action\(/;

function* abapFiles(dir) {
  for (const entry of readdirSync(dir)) {
    const p = join(dir, entry);
    if (statSync(p).isDirectory()) yield* abapFiles(p);
    else if (p.endsWith(".abap")) yield p;
  }
}

export function patchFollowUpAction(root) {
  if (!existsSync(root)) {
    throw new Error(`patch_follow_up_action: ${root} not found — is the source copy complete?`);
  }
  let files = 0;
  let calls = 0;
  let already = 0;
  for (const file of abapFiles(root)) {
    const src = readFileSync(file, "utf8");
    already += (src.match(/=[ \t]*client->_event_client\(/g) || []).length;
    // comment lines ("! doc, * and " comments) are left as they are: they
    // document the API by its real name
    // a line ending in `&&` continues a concatenation, so a call starting the
    // NEXT line is consumed too — comment lines in between leave the state as
    // it is
    let concatOpen = false;
    const out = src
      .split("\n")
      .map((line) => {
        const trimmed = line.trimStart();
        if (trimmed.startsWith('"') || trimmed.startsWith("*")) return line;
        let patched = line.replace(WIRED, (_m, lhs) => {
          calls++;
          return `${lhs}client->_event_client(`;
        });
        if (concatOpen) {
          patched = patched.replace(CONTINUED, (_m, indent) => {
            calls++;
            return `${indent}client->_event_client(`;
          });
        }
        concatOpen = patched.trimEnd().endsWith("&&");
        return patched;
      })
      .join("\n");
    if (out !== src) {
      writeFileSync(file, out);
      files++;
    }
  }
  if (calls === 0) {
    if (already > 0) {
      // re-run over an already-patched copy (the builds always start from a
      // fresh copy, so this only happens by hand)
      console.log(`patch_follow_up_action: already patched — ${already} wired call(s) in ${root}`);
      return;
    }
    // the corpus stopped wiring follow_up_action in views, or the transpiler
    // learned IS SUPPLIED and this patch should be deleted — both are
    // decisions, not something to pass over in silence
    throw new Error(
      "patch_follow_up_action: no view-wired follow_up_action( ) call found in " +
        `${root} — if that is intended, drop this patch and its call sites`,
    );
  }
  console.log(`patch_follow_up_action: rewired ${calls} view-wired call(s) in ${files} file(s) under ${root}`);
}

// CLI: node patch_follow_up_action.mjs <path-to-copied-abap-tree>
if (process.argv[1] && fileURLToPath(import.meta.url) === resolve(process.argv[1])) {
  patchFollowUpAction(process.argv[2] || fileURLToPath(new URL("../src/ai-demokit", import.meta.url)));
}
