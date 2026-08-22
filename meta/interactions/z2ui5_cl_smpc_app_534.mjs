// the two inlined wizards and the linear current-step Select
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Wizard').length === 2,
    'the two inlined wizards never rendered');
  // the showcase flag makes the linear one visible and the branching one not
  await waitForUi5(page, () => {
    const w = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Wizard');
    return w.filter((c) => c.getVisible()).length === 1 && w.find((c) => c.getVisible()).getEnableBranching() === false;
  }, 'the showcase expression never reached the two wizards');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.WizardStep').length === 13,
    'the 4 linear + 9 branching steps never rendered');
  // the branching wizard is not VISIBLE at boot (the showcase starts linear),
  // so its radio buttons are read off the registry rather than the rendered body
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.RadioButton')
    .some((c) => c.getText() === 'A->B1->C->D->E->F1->F2->G'),
    'the three branching path radio buttons never reached the branching wizard');
};
