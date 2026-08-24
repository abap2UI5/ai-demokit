// global BusyIndicator show(0) + START_TIMER hide chain (2026-07-30 rework)
//
// What this module has to separate, and why it is written this way: the
// FRAMEWORK drives the same global singleton on every round-trip -
// View1.controller.js calls BusyIndicator.show() when a request goes out and
// BusyIndicator.hide() in the finally of _processAfterRendering, BEFORE the
// port's own follow-up JS runs. So "the overlay appeared, then it was gone"
// is satisfied by any round-trip whatsoever and proves nothing about the
// port's wire. What the framework cannot do is hold the overlay up while the
// app is idle: its own hide() has already run by the time rendering finishes.
// The port's show(0) + START_TIMER( HIDE_BUSY, 4000 ) keeps it up for ~4s
// afterwards, so a visible episode measurably LONGER than a round-trip is the
// port's, and only the port's.
const MIN_VISIBLE_MS = 2000;

export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Show BusyIndicator', exact: true }).nth(1);
  await expect(btn, 'the zero-delay busy button').toBeVisibleEnabled();
  await btn.click();

  const visibleMs = await page.evaluate(async () => {
    const shown = () => {
      const el = document.getElementById('sapUiBusyIndicator');
      return !!el && el.offsetParent !== null;
    };
    const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
    const deadline = Date.now() + 25000;
    // the LAST episode within the window is the port's: the framework's own
    // round-trip overlay comes first and is over once rendering finished
    let last = 0;
    while (Date.now() < deadline) {
      if (!shown()) { await sleep(50); continue; }
      const from = Date.now();
      while (shown() && Date.now() < deadline) await sleep(50);
      last = Date.now() - from;
      if (last >= 2000) break;
    }
    return last;
  });

  await expect(visibleMs, 'the busy overlay held up by the port (not by the round-trip)')
    .toBeAtLeast(MIN_VISIBLE_MS);
};
