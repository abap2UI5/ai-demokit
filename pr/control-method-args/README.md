# Broaden CONTROL_METHODS argument kinds: `to` transition, ViewSettingsDialog `open` page, Wizard `goToStep`

## Motivation

The 2026-07-19 hold-out regeneration probe ported three demo kit samples
whose controllers pass an **argument** to an imperative control method that
the `CONTROL_METHODS` whitelist accepts only argument-less (or with fewer
kinds). `castArgs` maps over the declared `kinds`, so every extra argument
is **silently dropped** client-side — the call succeeds, the behavior is
quietly wrong:

- **sap.m.sample.NavContainer** — `navCon.to(sPageId, sAnimation)`: the
  whitelist entry is `to: ["controlId"]`, so the sample's animation Select
  (slide/baseSlide/fade/show) is a functional no-op; every navigation uses
  the default "slide".
- **sap.m.sample.ViewSettingsDialog** — `dialog.open(sPageId)`: the entry
  `open: []` (added 2026-07-18 for PDFViewer/Dialog popups) drops the page
  key, so "open filter view" / "preselected filters" buttons land on the
  sort page — 3 of the sample's 4 buttons lose their distinguishing
  behavior.
- **sap.m.sample.Wizard** — `wizard.goToStep(oStep, bFocus)`: not
  whitelisted at all; the port had to emulate Edit-links with
  `back` + `scrollIntoView` + `discardProgress`, which cannot reproduce
  "jump back without discarding".

## Current behavior

`app/webapp/core/FrontendAction.js`:

```js
const CONTROL_METHODS = {
  to: ["controlId"], back: [], focus: [], scrollToIndex: [], scrollTo: [],
  open: [], close: [], setExpanded: ["bool"], ...
};
castArgs = (args, kinds) => kinds.map((kind, i) => cast(args[i], kind));
```

Arguments beyond `kinds.length` never reach the method.

## Proposed change

Extend the whitelist entries (kinds only — the mechanism is untouched, so
this follows the pr/control-call-whitelist model: imperative methods /
arguments with no binding equivalent):

```js
to:       ["controlId", "string"],          // transitionName (slide|baseSlide|fade|show)
open:     ["string"],                        // ViewSettingsDialog page key ("filter", ...);
                                             // PDFViewer/Dialog.open() ignore extra args
goToStep: ["controlId", "bool"],             // Wizard: step id + focus flag
```

`cast(undefined, "string")` must keep returning `undefined` (not `""`), so
existing arg-less `open`/`to` calls stay byte-compatible.

## Example (NavContainer port)

```abap
client->follow_up_action( val   = client->cs_event-control_by_id
                          t_arg = VALUE #( ( `navCon` ) ( `` ) ( `to` )
                                           ( page_id ) ( animation ) ) ).
```

## Ports affected here

Hold-out samples only (probe `b90`, never merged) — but the same pattern
sits in the regular backlog: every NavContainer/Wizard/ViewSettingsDialog
family sample with a parametrized imperative call.
