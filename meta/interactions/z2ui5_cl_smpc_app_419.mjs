// the 1.127+ selectable menu: toggleBy anchored open, MenuItemGroup selection,
// endContent buttons - all client-side, the port has no backend wire
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  const btn = page.getByRole('button', { name: 'Open Menu', exact: true }).first();
  await expect(btn, 'the "Open Menu" anchor button').toBeVisibleEnabled();
  await btn.click();
  const item = page.getByText('Underline', { exact: true }).first();
  await expect(item, 'the anchored-open menu (toggleBy)').toBeVisibleEnabled();
  // the two endContent Buttons of the "Open" item render inside the menu
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.MenuItem'
    && c.getText() === 'Open' && c.getEndContent().length === 2),
  'the "Open" item never carried its two endContent Buttons');
  // Underline sits in the MultiSelect group and starts unselected - a click selects it
  await item.click();
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.MenuItem'
    && c.getText() === 'Underline' && c.getSelected() === true),
  'clicking Underline never set MenuItem.selected (MultiSelect group)');
  // Bold keeps its seeded selected=true next to it
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.MenuItem'
    && c.getText() === 'Bold' && c.getSelected() === true),
  'Bold lost its seeded selected mark');
};
