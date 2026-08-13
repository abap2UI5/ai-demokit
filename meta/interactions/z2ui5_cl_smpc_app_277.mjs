// the controller's phone/orientation MessageStrip rule became one device-
// model expression: on a desktop viewport the strip must be VISIBLE
export default async (page, expect) => {
  await expect(page.locator('body'), 'the device-model driven MessageStrip')
    .toContainText('Move the splitter to see the container based popin behaviour');
  await expect(page.locator('.sapMListTblHeader').first(), 'the left table header').toBeVisibleEnabled();
  await expect(page.locator('body'), 'both panes bound to the same collection').toContainText('Notebook Basic 15');
};
