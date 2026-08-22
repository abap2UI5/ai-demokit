// the per-keystroke liveChange round-trip feeding the getValue Text
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const input = page.locator('.sapMInputBaseInner').first();
  await expect(input, 'the type-here Input').toBeVisibleEnabled();
  await input.click();
  // type WITH a delay: the wire round-trips per keystroke and abap2UI5 drops an
  // event fired while one is still in flight, so a no-delay burst would assert
  // a value the wire never promised
  for (const ch of 'abc') {
    await input.press(ch);
    await page.waitForTimeout(900);
  }
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Text' && c.getText() === 'abc'),
    'the liveChange round-trip never reached the getValue Text');
};
