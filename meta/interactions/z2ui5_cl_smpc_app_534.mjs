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
  await expect(page.locator('body'), 'the branching path radio buttons').toContainText('A->B1->C->D->E->F1->F2->G');
};
