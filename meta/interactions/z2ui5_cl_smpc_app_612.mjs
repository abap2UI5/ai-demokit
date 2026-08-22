// the three MultiInputs, their bound suggestions, and the Link that lives
// inside the third one's formattedValueStateText
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const mi = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.MultiInput');
    return mi.length === 3;
  }, 'the three MultiInputs never rendered');
  // multiInput4 takes core:Item suggestions, the other two suggestion rows
  await waitForUi5(page, () => {
    const mi4 = ui5All().find((c) => c.getId().endsWith('multiInput4'));
    return mi4 && mi4.getSuggestionItems().length === 123;
  }, 'the sorted core:Item suggestions never reached multiInput4');
  await waitForUi5(page, () => ['multiInput2', 'multiInput3'].every((id) => {
    const mi = ui5All().find((c) => c.getId().endsWith(id));
    return mi && mi.getSuggestionRows().length === 123 && mi.getSuggestionColumns().length === 4;
  }), 'the 123 suggestion rows and four columns never reached the tabular MultiInputs');
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
  // the Link press: preventDefault on the wire, the toast on the way back
  await page.evaluate(() => {
    const reg = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    reg.find((c) => c.getMetadata().getName() === 'sap.m.Link' && c.getText() === 'link').firePress();
  });
  await expect(page.locator('.sapMMessageToast'), 'the value-state Link toast')
    .toContainText('You have pressed a link in value state message');
};
