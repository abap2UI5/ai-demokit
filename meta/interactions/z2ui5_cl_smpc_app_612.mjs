// the three MultiInputs, their bound suggestions, and the Link that lives
// inside the third one's formattedValueStateText
// NOTE: a JSONModel's default sizeLimit is 100 and neither the sample nor the
// port raises it, so a 123-row suggestion aggregation instantiates 100 —
// the original is capped the same way.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const mi = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.MultiInput');
    return mi.length === 3;
  }, 'the three MultiInputs never rendered');
  // multiInput4 takes core:Item suggestions, the other two suggestion rows
  await waitForUi5(page, () => {
    const mi4 = ui5All().find((c) => c.getId().endsWith('multiInput4'));
    return mi4 && mi4.getSuggestionItems().length === 100;
  }, 'the sorted core:Item suggestions never reached multiInput4');
  await waitForUi5(page, () => ['multiInput2', 'multiInput3'].every((id) => {
    const mi = ui5All().find((c) => c.getId().endsWith(id));
    return mi && mi.getSuggestionRows().length === 100 && mi.getSuggestionColumns().length === 4;
  }), 'the suggestion rows and four columns never reached the tabular MultiInputs');
  // the Information value state and its long text ride along on both
  await waitForUi5(page, () => ['multiInput2', 'multiInput3'].every((id) => {
    const mi = ui5All().find((c) => c.getId().endsWith(id));
    return mi && mi.getValueState() === 'Information'
      && mi.getValueStateText().startsWith('Information message. Extra long text');
  }), 'the Information value state never reached the tabular MultiInputs');
  // only the third carries the FormattedText value state message
  await waitForUi5(page, () => {
    const mi = ui5All().find((c) => c.getId().endsWith('multiInput3'));
    const ft = mi && mi.getFormattedValueStateText();
    return ft && ft.getHtmlText() === 'Recommendantion based on: %%0.' && ft.getControls().length === 1;
  }, 'the formattedValueStateText with its Link never reached multiInput3');
  // the conversion: each tabular MultiInput carries a z2ui5.cc.MultiInputExt
  // companion, and its tokenFromRow( ) builds the Token the sample's own
  // addValidator( ) builds - key = the Name cell, text = `key(price cell)`.
  // Asserted on a REAL bound suggestion row rather than through the popover:
  // this is the code path the conversion added, and it is deterministic.
  await waitForUi5(page, () => ['multiInput2', 'multiInput3'].every((id) => {
    const ext = ui5All().find((c) => c.getMetadata().getName() === 'z2ui5.cc.MultiInputExt'
      && c.getProperty('MultiInputId') === id);
    return ext && ext.getProperty('TokenKeyCell') === 0 && ext.getProperty('TokenTextCells') === '3';
  }), 'the MultiInputExt companions never reached the two tabular MultiInputs');
  await waitForUi5(page, () => ['multiInput2', 'multiInput3'].every((id) => {
    const ext = ui5All().find((c) => c.getMetadata().getName() === 'z2ui5.cc.MultiInputExt'
      && c.getProperty('MultiInputId') === id);
    const mi = ui5All().find((c) => c.getId().endsWith(id));
    const row = mi.getSuggestionRows()[0];
    const token = ext.tokenFromRow(row);
    // row 0 of the mock is Notebook Basic 15 / HT-1000 / … / 956 EUR, and the
    // price cell is the sample's composite sap.ui.model.type.Currency binding:
    // NumberFormat gives it the currency's two decimals AND separates the code
    // with a NO-BREAK space (trailingCurrencyCode defaults true, so the pattern
    // is `sap-standard-alphaNextToNumber` = `#,##0.00\u00a0¤`). `\s` matches that
    // space as well as a plain one, and the token text is composed from the
    // cell itself rather than spelled out a second time — a formatted currency
    // string is the browser's, not the port's (same rule as app 196).
    const price = row.getCells()[3].getText();
    return token && token.getKey() === 'Notebook Basic 15'
      && /^956\.00\sEUR$/.test(price)
      && token.getText() === `Notebook Basic 15(${price})`;
  }), 'the companion did not build the sample\'s token from a suggestion row');
  // the tokens are client-side now: nothing is bound, so the aggregation is
  // empty until somebody picks - which is what the original does too
  await waitForUi5(page, () => ['multiInput2', 'multiInput3'].every((id) => {
    const mi = ui5All().find((c) => c.getId().endsWith(id));
    return mi && mi.getTokens().length === 0 && !mi.getBinding('tokens');
  }), 'a tokens binding survived the conversion');
  // the Link press: preventDefault on the wire, the toast on the way back
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Link' && c.getText() === 'link').firePress();
  });
  await expect(page.locator('.sapMMessageToast'), 'the value-state Link toast')
    .toContainText('You have pressed a link in value state message');
};
