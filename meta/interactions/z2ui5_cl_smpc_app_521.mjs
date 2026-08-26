// the value-help SelectDialog, the picked DESCRIPTION landing on selectedKey,
// and the KeyValue rendering the sample is named after
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

// NOTE: the productInput lookup is inlined in each predicate on purpose —
// waitForUi5 stringifies the function and runs it in the PAGE, so it cannot
// call a helper from this module. The !bIsDestroyed / in-document filter keeps
// the outgoing copy a round-trip leaves in the registry out of the answer.

export default async (page, expect) => {
  // the value-help icon measures 0x0 in the unthemed harness — F4 on the
  // focused field raises the same valueHelpRequest through the control
  await page.locator('.sapMInputBaseInner').first().focus();
  await page.keyboard.press('F4');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.SelectDialog'),
    'the valueHelpRequest never opened the SelectDialog (popup_display)');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.StandardListItem' && c.getDomRef()).length > 0,
    'the SelectDialog rendered without its product rows');
  await page.locator('.sapMDialog .sapMSLI').first().click();
  // confirm carries the row's DESCRIPTION ({PRODUCTID}) — onValueHelpDialogClose
  // reads getDescription(), not getTitle() — and the backend writes it to
  // SELECTED_KEY, which is bound to the Input's selectedKey
  await waitForUi5(page, () => {
    const i = ui5All().find((c) => c.getId().endsWith('productInput')
      && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()));
    return !!i && i.getSelectedKey() === 'HT-1000';
  }, 'the picked description never reached the Input selectedKey (VALUE_HELP_CLOSE)');
  // textFormatMode="KeyValue": the property-binding update calls the control's
  // own setSelectedKey, which resolves the key against suggestionItems and
  // writes `(key) text` into the field — the subject of the sample
  await waitForUi5(page, () => {
    const i = ui5All().find((c) => c.getId().endsWith('productInput')
      && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()));
    return !!i && i.getValue() === '(HT-1000) Notebook Basic 15';
  }, 'selectedKey never rendered as the KeyValue form "(HT-1000) Notebook Basic 15"');
  // the original sets the indicator on the value-help path too (setText(sDescription))
  await expect(page.locator('[id$="selectedKeyIndicator"]'), 'the Selected Key indicator')
    .toContainText('HT-1000');
};
