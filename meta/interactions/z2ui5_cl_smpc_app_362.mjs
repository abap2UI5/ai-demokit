// Sorting: the column sort is vetoed on the client (check_prevent_default) and
// re-done by an ABAP SORT, so what has to be proven is the ORDER that comes
// back — plus the header indicator the bound Column pair draws.
//
// The order is read off the first visible row's binding context rather than
// off a cell's rendered text: the cell is what a formatter produced, the
// context is what the server actually put at the head of the model.
//
// The INDICATOR is read off the rendered class, not off getSortOrder( ).
// Since 2026-08-24 the port binds `sortOrder` to an expression that yields
// only 'Ascending' or 'Descending' — never 'None' — because seeding the enum's
// None would have pushed the port past its 1.71 floor (None only joined the
// enum the property was retyped to at 1.120). The None-ness lives in the
// `sorted` boolean instead, bound to `!== 'None'`, and that is the half
// TableRenderer._addColumnSortAndFilterClasses actually obeys: it derives
// bSorted from the sortOrder, then a deprecated block still present through
// 1.151 zeroes it again with `if (!oColumn.getSorted()) { bSorted = false; }`.
// So `sapUiTableColSorted` on the column's own header cell is the one reading
// that answers the question "does the header show a sort?", and asserting
// getSortOrder( ) === 'None' asserts a state this port can no longer reach.
import { waitForUi5, ui5All, UI5_ALL_SRC, revealInOverflow } from '../../scripts/lib-e2e.mjs';

// One dump of everything the assertions below read. Controls are filtered down
// to the LIVE ones: every round-trip rebuilds the view and Element.registry
// keeps the outgoing control while it is torn down — neither destroyed nor
// null-ref'd, just detached — so an unfiltered find() answers with the
// previous table and its previous state.
const SNAP = `(() => { ${UI5_ALL_SRC}
  const live = (c) => !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef());
  const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table' && live(c));
  const rows = t ? t.getRows() : [];
  const ctx = rows.length ? rows[0].getBindingContext() : null;
  const cols = (t ? t.getColumns() : []).filter((c) => c.getSortProperty() && live(c)).map((c) => ({
    property: c.getSortProperty(),
    sortOrder: c.getSortOrder(),
    sorted: c.getSorted(),
    shown: c.getDomRef().classList.contains('sapUiTableColSorted'),
    descending: c.getDomRef().classList.contains('sapUiTableColSortedD')
  }));
  return {
    name: ctx ? ctx.getProperty('NAME') : null,
    category: ctx ? ctx.getProperty('CATEGORY') : null,
    date: ctx ? ctx.getProperty('DELIVERYDATESTR') : null,
    cols
  }; })()`;

const snap = async (page) => page.evaluate(SNAP);

// Which sortProperties currently draw an indicator, as a stable string.
const shownOn = (s) => s.cols.filter((c) => c.shown).map((c) => c.property).sort().join(',');

export default async (page, expect) => {
  await expect(page.locator('body'), 'the Product Name column').toContainText('Product Name');

  // the port applies a NAME ascending sort on init, so the head of the model
  // is already the sorted one — not the first row of products.json
  const start = await snap(page);
  if (start.name !== '10" Portable DVD player') {
    throw new Error(`the init sort did not reach the model (first row is "${start.name}")`);
  }
  // ... and the init indicator sits on NAME alone. This is the baseline every
  // wait below is a CHANGE from, so it is asserted rather than assumed.
  if (shownOn(start) !== 'NAME') {
    throw new Error(`the init sort indicator is not on NAME alone (shown on: "${shownOn(start)}")`);
  }
  // the sortOrder values are asserted as members of the enum: this port used
  // to die on `"" is of type string, expected sap.ui.core.SortOrder` when an
  // unsorted column serialized its initial value as an empty string
  for (const c of start.cols) {
    if (!['None', 'Ascending', 'Descending'].includes(c.sortOrder)) {
      throw new Error(`column ${c.property} carries a non-enum sortOrder "${c.sortOrder}"`);
    }
  }

  // ---- sortCategoriesAndName: Category ascending, then Name ascending ----
  const sortBoth = page.getByRole('button', { name: 'Sort ascending across Categories and Name' }).first();
  await revealInOverflow(page, sortBoth);
  await sortBoth.click();
  // Wait on the CATEGORY indicator, not on the head row's category: the model
  // already opens with an Accessories row at the head (name-ascending puts
  // `10" Portable DVD player` first), so a head-row check is true BEFORE the
  // click and waits for nothing — the module then raced its next round-trip
  // against this one. CATEGORY draws no indicator until this button lands.
  await waitForUi5(page, () => {
    const live = (c) => !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef());
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table' && live(c));
    return !!t && t.getColumns().some((c) => c.getSortProperty() === 'CATEGORY' && live(c)
      && c.getDomRef().classList.contains('sapUiTableColSorted'));
  }, 'the category+name sort did not reach the bound Column indicator');
  const sorted = await snap(page);
  if (sorted.category !== 'Accessories') {
    throw new Error(`the sorted model does not start on Accessories (got "${sorted.category}")`);
  }
  // both keys of the two-column sort show, and nothing else does
  if (shownOn(sorted) !== 'CATEGORY,NAME') {
    throw new Error(`the category+name sort indicator is not on CATEGORY and NAME (shown on: "${shownOn(sorted)}")`);
  }

  // ---- clearAllSortings: re-seed the model, drop every indicator ----
  // The original's binding.sort(null) + _resetSortingState. What comes back is
  // sortOrder 'None' IN THE MODEL, which the port renders as sorted=false —
  // the bound sortOrder property itself never says 'None' (see the header).
  const clear = page.getByRole('button', { name: 'Clear all sortings' }).first();
  await revealInOverflow(page, clear);
  await clear.click();
  await waitForUi5(page, () => {
    const live = (c) => !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef());
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table' && live(c));
    const rows = t ? t.getRows() : [];
    const ctx = rows.length ? rows[0].getBindingContext() : null;
    return !!ctx && ctx.getProperty('NAME') === 'Notebook Basic 15'
      && t.getColumns().filter((c) => c.getSortProperty() && live(c))
           .every((c) => c.getSorted() === false
             && !c.getDomRef().classList.contains('sapUiTableColSorted'));
  }, 'clearing the sortings did not restore the seeded order with every indicator off');

  // ---- the column header menu's own sort: the `sort` event and its veto ----
  // The toolbar legs above never fire it, which is why this port's LIVE_TEST
  // stayed open. Column._sort( ) is the method the menu's Sort entry calls: it
  // ends in oTable.fireSort({ column, sortOrder, columnAdded }) and returns
  // early when a handler vetoes, so the port's check_prevent_default leg and
  // its two event args (${$parameters>/column}.getSortProperty() and
  // ${$parameters>/sortOrder}) are driven exactly as a real menu press drives
  // them. The menu itself is not clicked: sap.ui.table builds it lazily
  // through ColumnHeaderMenuAdapter into a sap.ui.unified.Menu popup, which
  // the unthemed harness cannot lay out — same call-the-menu-action route
  // app 571 takes for its column menu.
  //
  // The veto is what makes this observable: if the client sort ran, Column._sort
  // would setSorted/setSortOrder itself and the indicator would move with no
  // round-trip at all. Vetoed, the ONLY thing that can move it is the model
  // the backend sends back.
  await page.evaluate(`(() => { ${UI5_ALL_SRC}
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table' && !c.bIsDestroyed);
    const col = t && t.getColumns().find((c) => c.getSortProperty() === 'DELIVERYDATESTR');
    if (!col) { throw new Error('no Delivery Date column to fire the sort event on'); }
    col._sort('Descending');
  })()`);
  await waitForUi5(page, () => {
    const live = (c) => !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef());
    const t = ui5All().find((c) => c.getMetadata().getName() === 'sap.ui.table.Table' && live(c));
    return !!t && t.getColumns().some((c) => c.getSortProperty() === 'DELIVERYDATESTR' && live(c)
      && c.getDomRef().classList.contains('sapUiTableColSortedD'));
  }, 'the column sort event did not bring back a Descending indicator on the Delivery Date column');
  const byDate = await snap(page);
  // the timestamp is the sort key (the dd/MM/yyyy string cannot be compared as
  // text — the reason the original installs a custom Sorter.fnCompare at all),
  // and the latest date in the mock is 23/07/2026
  if (byDate.date !== '23/07/2026') {
    throw new Error(`the delivery-date sort did not order by the timestamp (head row is "${byDate.date}")`);
  }
  // "No multi-column sorting": the pressed column is the only one indicated
  if (shownOn(byDate) !== 'DELIVERYDATESTR') {
    throw new Error(`the column sort left another indicator standing (shown on: "${shownOn(byDate)}")`);
  }
};
