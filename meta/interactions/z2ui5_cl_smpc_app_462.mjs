// the liveChange wire feeding the getValue Text. It is round-trip-free since
// 2026-08-28 (follow_up_action control_by_id getValue/setText), so typing needs
// no delay — there is no trip left to drop an event. The clearing keystroke is
// asserted on its own: an empty argument used to be inferred as the boolean
// false and rendered the four characters "false", which is the defect
// abap2UI5's control-action-empty-string-arg fix removed.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const input = page.locator('.sapMInputBaseInner').first();
  await expect(input, 'the type-here Input').toBeVisibleEnabled();
  await input.click();
  await input.pressSequentially('abc');
  await waitForUi5(page,
    () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Text' && c.getText() === 'abc'),
    'the liveChange wire never reached the getValue Text');
  // clear it: the Text has to go EMPTY, never to the literal word "false"
  await input.fill('');
  await waitForUi5(page,
    () => {
      const texts = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Text');
      return texts.some((c) => c.getId().endsWith('getValue') && c.getText() === '')
        && !texts.some((c) => c.getText() === 'false');
    },
    'clearing the Input left the getValue Text non-empty (the "false" cast is back?)');
};
