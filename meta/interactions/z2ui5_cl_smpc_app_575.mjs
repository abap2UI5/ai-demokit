// TableScrollToIndex: the flexible column layout, its master table, the detail
// column - and the sample's actual subject, the pressed row's index travelling
// to the backend and coming back as a scrollToIndex control call once the begin
// column has finished resizing.
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

// the row to press. NOT 0: press_index starts at -1 and the ABAP guard is
// `press_index >= 0`, so a zero would be satisfied by a wire that records
// nothing and by a scrollToIndex called with a constant. 7 is inside the
// growing threshold (20), so the row is rendered and no growth request is
// needed to reach it - and it sits in the stretch of the NAME order where a
// codepoint sort and a locale collation still agree (they part at 12/13, over
// "CD/DVD case" vs "Camcorder View"), so the leg reads the wire and not the
// difference between ABAP's SORT ... AS TEXT and UI5's Sorter.
const ROW = 7;

export default async (page, expect) => {
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'OneColumn';
  }, 'the flexible column layout never started on one column');
  await waitForUi5(page, () => {
    const t = ui5All().find((c) => c.getId().endsWith('productsTable'));
    return t && t.getItems().length > 0;
  }, 'the master table never rendered its rows');
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Title'
    && c.getText() === 'Products (123)'), 'the master title never got its total count');

  // scrollToIndex leaves no state on the control - it moves the scroll
  // container, which in the unthemed harness is not a difference worth
  // reading - so the control call itself is the observable: record every
  // invocation on the table instance the layout actually rendered, then let
  // UI5's own implementation run. LIST_ITEM answers with a model delta and no
  // view_display( ), so this instance survives the round trip.
  const spy = await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const t = ui5All().find((c) => c.getId().endsWith('productsTable')
      && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()));
    if (!t) return 'the master table is in the registry but was never rendered';
    if (typeof t.scrollToIndex !== 'function') return 'sap.m.Table has no scrollToIndex on this UI5 version';
    window.__scrollToIndexCalls = [];
    const original = t.scrollToIndex.bind(t);
    t.scrollToIndex = function (i) { window.__scrollToIndexCalls.push(i); return original(i); };
    const item = t.getItems()[${ROW}];
    if (!item) return 'the master table rendered fewer than ${ROW} + 1 rows';
    // a ColumnListItem has no title of its own - the row's identity is the
    // NAME of the record its binding context resolves to
    const ctx = item.getBindingContext();
    if (!ctx) return 'the row at index ${ROW} has no binding context';
    window.__pressedTitle = ctx.getObject().NAME;
    return null;
  })()`);
  if (spy) throw new Error(`arming the scrollToIndex probe: ${spy}`);

  // pressing a row folds that product into the detail column and opens it
  const pressed = await page.evaluate(`(() => {
    const ui5All = () => Object.values(sap.ui.require("sap/ui/core/Element").registry.all());
    const t = ui5All().find((c) => c.getId().endsWith('productsTable') && !c.bIsDestroyed && c.getDomRef());
    t.getItems()[${ROW}].firePress();
    return window.__pressedTitle;
  })()`);
  await waitForUi5(page, () => {
    const fcl = ui5All().find((c) => c.getMetadata().getName() === 'sap.f.FlexibleColumnLayout');
    return fcl && fcl.getLayout() === 'TwoColumnsMidExpanded';
  }, 'pressing a row never opened the mid column');

  // the sample's subject. The layout change resizes the begin column, the FCL
  // answers with columnResize(beginColumn=true), and onColumnResize scrolls
  // the row the user came from back into view - with the index the LIST_ITEM
  // round trip recorded, not with a constant.
  await page.waitForFunction('window.__scrollToIndexCalls && window.__scrollToIndexCalls.length > 0', undefined, { timeout: 15000 })
    .catch(() => { throw new Error('the begin column resized and no scrollToIndex ever reached the master table — the COLUMN_RESIZE wire did not issue the follow-up action'); });
  const calls = await page.evaluate('window.__scrollToIndexCalls');
  if (Number(calls[0]) !== ROW) {
    throw new Error(`the layout change scrolled the master table to index ${JSON.stringify(calls[0])}, not to the pressed row ${ROW} (${pressed})`);
  }

  // the folded detail fields reach the object page's form, and they are the
  // PRESSED product's - detail_bind( ) resolves the row by its product id
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Label' && c.getText() === 'Product ID')
    && ui5All().some((c) => c.getMetadata().getName() === 'sap.uxap.ObjectPageLayout'),
    'the detail column stayed empty');
  await waitForUi5(page, (title) => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.Title'
    && c.getText() === title), `the detail column does not show the pressed product ${pressed}`, pressed);

  // the close button is only offered while a mid column is open
  await waitForUi5(page, () => ui5All().some((c) => c.getMetadata().getName() === 'sap.m.OverflowToolbarButton'
    && c.getTooltip() === 'Close column' && c.getVisible() === true),
    'the close-column button never appeared');
};
