// valueLiveUpdate off: the liveChange round-trip fills GET_VALUE while the
// TextArea's OWN model field (and with it the second Text) must NOT follow
// yet — that gap is the sample's point, so both legs are asserted. Type with
// a delay: abap2UI5 serializes round-trips, so keystrokes fired while one is
// in flight are dropped and GET_VALUE would hold the last COMPLETED value
// (measured 2026-08-02 — see the port's sidecar NOTE).
export default async (page, expect) => {
  const ta = page.locator('textarea').first();
  await expect(ta, 'the TextArea').toBeVisibleEnabled();
  await ta.click();
  await ta.pressSequentially('abc', { delay: 700 });
  await expect(page.locator("[id$='getValue']"), 'the liveChange round-trip filling GET_VALUE').toContainText('abc');
  // two nodes end in the id — the SimpleForm's grid wrapper and the Text itself
  const lagging = await page.locator("[id$='getProperty']").last().innerText();
  if (lagging.includes('abc')) throw new Error('model.getProperty() already followed although valueLiveUpdate is off');
  // flip the Switch: valueLiveUpdate is two-way bound, so the model now follows too
  await page.locator('.sapMSwtCont').first().click();
  await ta.click();
  await ta.pressSequentially('de', { delay: 700 });
  await expect(page.locator("[id$='getProperty']"), 'the model field once valueLiveUpdate is on').toContainText('abc');
};
