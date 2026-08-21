// A static port — no wire to drive, so the deviation is purely about what the
// page PAINTS: the light-blue 24em outer div containing the blue 16em inner
// div with a 1em margin, inlined as a core:HTML block inside the subsection's
// blocks aggregation. Asserted through the geometry rather than the markup:
// em resolves against the theme's font size, so absolute pixel counts would
// pin the assertion to a theme, while "the inner box sits inside the outer one
// and is inset by a margin" is the sample's actual point.
export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageLayout'), 'the ObjectPageLayout').toBeVisibleEnabled();
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header identifier').toContainText('Block in Block');
  await expect(page.locator('body'), 'the subsection title').toContainText('Example');

  const box = await page.evaluate(() => {
    const outer = [...document.querySelectorAll('div')]
      .find((d) => getComputedStyle(d).backgroundColor === 'rgb(169, 234, 255)');
    if (!outer) return { err: 'no light-blue outer block rendered' };
    const inner = [...outer.querySelectorAll('div')]
      .find((d) => getComputedStyle(d).backgroundColor === 'rgb(0, 0, 255)');
    if (!inner) return { err: 'the outer block contains no blue inner block' };
    const o = outer.getBoundingClientRect();
    const i = inner.getBoundingClientRect();
    return { outerH: o.height, innerH: i.height, margin: getComputedStyle(inner).marginTop, inset: i.top - o.top };
  });
  if (box.err) throw new Error(box.err);
  if (!(box.outerH > box.innerH && box.innerH > 0)) {
    throw new Error(`the inner block must be shorter than the outer one (outer ${box.outerH}, inner ${box.innerH})`);
  }
  if (parseFloat(box.margin) <= 0 || box.inset <= 0) {
    throw new Error(`the inner block must be inset by its 1em margin (margin ${box.margin}, inset ${box.inset})`);
  }
};
