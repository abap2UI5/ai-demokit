// the six MultiComboBox value states and the two FormattedText value-state texts
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.MultiComboBox').length === 6,
    'the six MultiComboBoxes never rendered');
  await waitForUi5(page, () => {
    const states = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.MultiComboBox').map((c) => c.getValueState());
    return ['Success', 'Information', 'Warning', 'Error'].every((s) => states.includes(s));
  }, 'the four value states never reached the MultiComboBoxes');
  // the two post-1.71 formattedValueStateText aggregations carry a FormattedText
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.MultiComboBox')
    .filter((c) => c.getFormattedValueStateText && c.getFormattedValueStateText()).length === 2,
    'the two formattedValueStateText aggregations never reached their MultiComboBox');
};
