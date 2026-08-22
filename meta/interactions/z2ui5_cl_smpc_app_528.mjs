// the four grids, their panels and the seven rebuilt cards
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.f.GridContainer').length === 4,
    'the four GridContainers never rendered');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.f.Card' && c.getDomRef()).length === 7,
    'the seven rebuilt cards never rendered');
  for (const t of ['Group 1', 'Group 2', 'Group 3', 'Group 4']) {
    await expect(page.locator('body'), 'the panel headers').toContainText(t);
  }
  await expect(page.locator('body'), 'the Object card rebuilt from objectContent/contact').toContainText('Peach Valley Inc.');
  await expect(page.locator('body'), 'the Table card rebuilt from tableContent/employees').toContainText('Birthdates of Employees');
};
