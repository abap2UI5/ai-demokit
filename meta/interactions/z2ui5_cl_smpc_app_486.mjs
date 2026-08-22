// the anchored popover opened from the active ObjectHeader title
//
// NOTE: the title is addressed by its TEXT. `.sapMOHTitle` is the container
// and a click on it never reaches the control's own press handling in the
// unthemed harness — measured 2026-08-22: the popover stayed closed while a
// click on the title text opened it, and so did firing titlePress through the
// registry. The text click is the one that proves the real gesture.
//
// The popover is then read through the CONTROL, not with toContainText: an
// open popover measures zero in the unthemed harness, so Playwright's
// visibility check times out on a popover that is on screen and correct.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const oh = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ObjectHeader');
    return oh && oh.getTitleActive() === true && !!oh.getDomRef();
  }, 'the ObjectHeader never came up with an active title');
  await page.getByText('Notebook Basic 15', { exact: true }).first().click();
  await waitForUi5(page, () => {
    const po = ui5All().find((c) => c.getId().endsWith('myPopover'));
    return po && po.isOpen() && po.getContent().some((x) => (x.getText ? x.getText() : '').includes('more content goes here'));
  }, 'the title press never opened the anchored popover with its content');
};
