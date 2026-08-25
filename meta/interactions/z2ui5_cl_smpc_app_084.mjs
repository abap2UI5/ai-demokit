// sap.m.URLHelper — the four .eF('URLHELPER', …) wires, read off URLHelper's
// own public `redirect` event (2026-08-25, for the LIVE_TEST the sidecar
// retired)
//
// These presses do NOT round-trip. follow_up_action( ) WIRED IN THE VIEW emits
// the client event `.eF('URLHELPER','TRIGGER_TEL',{ TEL: '+49 6227 747474' })`
// straight into the press handler (z2ui5_cl_ui5_srv_event=>get_event_client),
// so no POST ever leaves the browser and page.waitForResponse has nothing to
// wait for. What IS observable is the far end of the chain: sap.m.URLHelper's
// redirect( ) fires a public `redirect` event carrying the FINISHED URI before
// it hands it to the browser (sap/m/library.js), and all four actions end
// there — triggerTel/triggerSms through normalizeTel/normalizeSms,
// triggerEmail through normalizeEmail, REDIRECT directly. Attaching to that
// event reads exactly what the wire delivered, through the framework's real
// handler (.abap2UI5/app/webapp/core/actions/Browser.js — evUrlHelper reads
// args[2] as an OBJECT and passes params.TEL / params.EMAIL / params.URL on),
// with nothing stubbed and no control property set behind the wire's back.
//
// This is the claim the sidecar's LIVE_TEST retired: before 2026-08-23 tel and
// sms were wired with a PRIMITIVE string, so params.TEL came out undefined,
// formatTel( ) returned '' and URLHelper was handed a bare `tel:` / `sms:`
// with no number in it — which a live note saying "the triggers all fire"
// cannot tell apart from a working wire. So the assertions pin the NUMBER.
//
// ONE user gesture per tab, and why the other three legs are fired on the
// control (measured 2026-08-25, the whole reason this module is shaped this
// way): the first press really navigates — URLHelper.redirect( ) assigns
// `window.location.href = "tel:+496227747474"` — and Chromium has no handler
// for an external protocol, so it never commits the navigation AND never
// delivers another input event to that tab. After the Telephone click, a
// second `.click()` reports success while NO mousedown/click reaches the DOM
// at all, `focus()` + Enter is swallowed the same way, and even a full
// page.goto( ) reload does not bring input back — the suppression outlives the
// document. Playwright cannot see this: it dispatches through CDP and reports
// the click as done, so the leg fails 10 s later as "the wire did not fire",
// which reads exactly like a dead port.
// So Telephone is driven by a real click — that proves the DisplayListItem's
// Active tap → press → .eF( ) path end to end — and the other three fire the
// control's OWN press event, which invokes the very handler the view wired
// (the module asserts the item HAS that one listener before firing, so an
// unwired item fails instead of passing silently). Everything after the press
// — the .eF dispatch, evUrlHelper, params.TEL/EMAIL/URL, URLHelper — runs
// unchanged; only the browser gesture in front of it is skipped, on the three
// legs where this harness can no longer deliver one.
//
// What this module does NOT prove, and cannot:
//   * that a dialer, SMS app or mail client actually opens. Headless Chromium
//     registers no external-protocol handler (that is the input effect above),
//     so `tel:`, `sms:` and `mailto:` are dropped after the event has fired.
//     Everything up to and including the URI the browser is asked to open is
//     proven here; the OS hand-off is not observable in this harness and
//     stays with a human live run.
//   * that the Website leg really LANDS on http://www.sap.com. That request is
//     aborted at the context route below — the harness has no egress, and a
//     foreign page loading inside the run is precisely what a redirect check
//     must not do. Proven: the URL reaches URLHelper.redirect( ) unmangled.

// URLHelper.formatTel( ) keeps only [0-9+*#], so the spaces of the bound
// numbers are stripped; normalizeEmail( ) percent-encodes address and subject
// and drops the false BODY/CC/BCC of the original controller.
const EXPECTED = [
  ['Telephone', 'tel:+496227747474'],
  ['SMS', 'sms:+49173123456'],
  ['Email', 'mailto:john.smith%40sap.com?subject=Info%20Request'],
  ['Website', 'http://www.sap.com'],
];

// `null` means the recorder array itself is gone — the document was replaced,
// i.e. the browser followed a hand-off URI and took the app under test off the
// page. Worth its own message; every other empty result is a wire that did not
// fire.
const readHits = (page) =>
  page.evaluate(() => (Array.isArray(window.__urlHelperHits) ? window.__urlHelperHits : null));

// Fire the press the view declared, on the item itself. Refuses an item that
// is not Active or carries no press listener, so a lost wire fails here with
// what it lost instead of timing out later as "nothing happened".
async function firePressOf(page, label) {
  const why = await page.evaluate((sLabel) => {
    const Element = sap.ui.require('sap/ui/core/Element');
    const item = Object.values(Element.registry.all()).find((c) => !c.bIsDestroyed
      && c.getMetadata().getName() === 'sap.m.DisplayListItem' && c.getLabel() === sLabel);
    if (!item) return `no DisplayListItem labelled "${sLabel}"`;
    if (item.getType() !== 'Active') return `the "${sLabel}" item is type ${item.getType()}, not Active — it cannot be pressed`;
    if (!item.hasListeners('press')) return `the "${sLabel}" item has no press handler — the view wired none`;
    item.firePress();
    return null;
  }, label);
  if (why) throw new Error(why);
}

async function catchRedirect(page, label, before) {
  const deadline = Date.now() + 10000;
  for (;;) {
    const hits = await readHits(page);
    if (hits === null) throw new Error(`the "${label}" hand-off navigated the page away — the app under test is gone`);
    if (hits.length > before) return hits[hits.length - 1];
    if (Date.now() > deadline) {
      throw new Error(`the "${label}" press never reached sap.m.URLHelper.redirect( ) — the .eF('URLHELPER', …) wire did not fire`);
    }
    await new Promise((r) => setTimeout(r, 200));
  }
}

export default async (page, expect) => {
  // the Website leg hands a real external URL to the browser; keep the request
  // off the wire (see the header) — the assertion is the URL, not the load
  await page.context().route('**://www.sap.com/**', (route) => route.abort());

  // the element binding on /S_SUPPLIER must have reached the items first, or an
  // empty value would produce a bare `tel:` for a reason that is NOT the one
  // this module exists to catch
  await expect(page.locator('.sapMList'), 'the /S_SUPPLIER-bound list')
    .toContainText('+49 6227 747474');

  const attached = await page.evaluate(() => {
    const lib = sap.ui.require('sap/m/library');
    if (!lib || !lib.URLHelper) return false;
    window.__urlHelperHits = [];
    // redirect( ) fires as fireEvent("redirect", sURL) — the URL is the whole
    // parameter object, so getParameters( ) is the value and getParameter(…)
    // would answer undefined
    lib.URLHelper.attachRedirect((oEvent) => {
      window.__urlHelperHits.push(String(oEvent.getParameters()));
    });
    return true;
  });
  if (!attached) throw new Error('sap/m/library is not loaded — cannot listen on URLHelper.redirect');

  for (let i = 0; i < EXPECTED.length; i++) {
    const [label, want] = EXPECTED[i];
    if (i === 0) {
      // the one leg this tab can still be given a real gesture
      const item = page.locator('li.sapMDLI').filter({ hasText: label }).first();
      await expect(item, `the "${label}" list item`).toBeVisibleEnabled();
      await item.click();
    } else {
      await firePressOf(page, label);
    }
    const got = await catchRedirect(page, label, i);
    if (got !== want) {
      throw new Error(`the "${label}" wire handed URLHelper "${got}", expected "${want}"`
        + ' — the t_arg object literal did not arrive intact (a scheme with nothing behind it is'
        + ' the { TEL: … } / { EMAIL: … } / { URL: … } parameter never reaching evUrlHelper)');
    }
  }

  // all four hand-offs, and the app is still standing: none of them replaced
  // the document the port renders into
  await expect(page.locator('.sapMList'), 'the app after all four URLHelper triggers')
    .toContainText('Red Point Stores');
};
