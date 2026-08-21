// TOGGLE_TITLE round-trip on the bound ObjectPageLayout.subSectionLayout:
// the backend flips TitleOnTop <-> TitleOnLeft and pushes it back, and the
// bound property has to re-layout the subsection titles live. Pressed TWICE,
// because a COND that only ever ran its first leg would pass a single click.
// The eight inlined core:HTML blocks are asserted alongside it — the second
// half of the deviation is that the ObjectPage renders them at all.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const layoutIs = (want) => {
  const l = ui5All().find((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout');
  return !!l && l.getSubSectionLayout() === want;
};

export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header identifier').toContainText('ObjectPage BlockBase');
  await expect(page.locator('body'), 'the columnLayout subsections').toContainText('Blocks with columnLayout 1');
  await expect(page.locator('body'), 'the WithInfo block content').toContainText('ShowSubsectionMore = true');

  // the eight core:HTML block divs really painted (they carry the sample's
  // #A9EAFF fill; a block that failed to inline would leave nothing behind)
  const blocks = await page.evaluate(() => [...document.querySelectorAll('div')]
    .filter((d) => getComputedStyle(d).backgroundColor === 'rgb(169, 234, 255)').length);
  if (blocks < 8) throw new Error(`expected the 8 inlined core:HTML blocks to render, found ${blocks}`);

  await waitForUi5(page, layoutIs, 'subSectionLayout did not start on TitleOnTop', 'TitleOnTop');
  const btn = page.getByRole('button', { name: 'toggle title', exact: true }).first();
  await expect(btn, 'the "toggle title" header action button').toBeVisibleEnabled();
  await btn.click();
  await waitForUi5(page, layoutIs, 'TOGGLE_TITLE did not reach the bound subSectionLayout (TitleOnLeft)', 'TitleOnLeft');
  await btn.click();
  await waitForUi5(page, layoutIs, 'the second press did not flip subSectionLayout back to TitleOnTop', 'TitleOnTop');
};
