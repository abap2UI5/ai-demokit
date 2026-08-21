// BlockBase eventing, the two halves of the deviation:
// (a) the DUMMY press round-trip — the $event.oSource.getParent().getParent()
//     .sId parent-chain arg has to resolve to the stand-in VBox's RUNTIME id
//     (abap2UI5 prefixes view-declared ids, so the toast can only be matched
//     on its shape, never on the literal `block`), and the server composes the
//     text from it;
// (b) the injected .dummyContainer2 rule winning over the m:VBox flex display,
//     which is what makes the inner container shrink-wrap the button the way
//     the original html:div does.
export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header identifier').toContainText('Eventing Blocks');

  const css = await page.evaluate(() => {
    const inner = document.querySelector('.dummyContainer2');
    const outer = document.querySelector('.dummyContainer1');
    if (!inner || !outer) return { err: 'the dummyContainer VBoxes did not render' };
    return { display: getComputedStyle(inner).display, background: getComputedStyle(outer).backgroundColor };
  });
  if (css.err) throw new Error(css.err);
  if (css.display !== 'inline-block') {
    throw new Error(`.dummyContainer2 must compute display:inline-block (the VBox flex display would leave "${css.display}")`);
  }
  if (css.background !== 'rgb(169, 234, 255)') {
    throw new Error(`.dummyContainer1 did not take the injected background (got ${css.background})`);
  }

  const btn = page.getByRole('button', { name: 'press me to fire an event' }).first();
  await expect(btn, 'the eventing button').toBeVisibleEnabled();
  await btn.click();
  const toast = page.locator('.sapMMessageToast').last();
  await expect(toast, 'the DUMMY toast').toBeVisibleEnabled();
  const text = (await toast.innerText()).trim();
  const m = /^dummy event fired by control (.+)$/.exec(text);
  if (!m) throw new Error(`the toast did not carry the composed text (got "${text}")`);
  if (!m[1].includes('block')) {
    throw new Error(`the parent-chain arg did not resolve to the outer VBox's id (toast carried "${m[1]}")`);
  }
};
