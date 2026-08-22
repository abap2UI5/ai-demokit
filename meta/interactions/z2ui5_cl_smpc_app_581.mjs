// the three GridLists, their box widths and the design gallery inside them
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // three GridLists with 3/2/2 boxes
  await waitForUi5(page, () => {
    const gl = ui5All().filter((c) => c.getMetadata().getName() === 'sap.f.GridList');
    return gl.length === 3 && gl.map((g) => g.getItems().length).join(',') === '3,2,2';
  }, 'the three GridLists never rendered with 3/2/2 boxes');

  // the three box widths are what the sample contrasts
  await waitForUi5(page, () => {
    const gl = ui5All().filter((c) => c.getMetadata().getName() === 'sap.f.GridList');
    return gl.map((g) => g.getCustomLayout().getBoxWidth()).join(',') === '15rem,22.5rem,17.5rem';
  }, 'the three GridBoxLayout box widths never reached the lists');

  // the first list contrasts three OverflowToolbar designs
  await waitForUi5(page, () => {
    const gl = ui5All().filter((c) => c.getMetadata().getName() === 'sap.f.GridList');
    const designs = gl[0].getItems().map((it) => it.getContent()[0].getItems()[1].getDesign());
    return designs.join(',') === 'Solid,Solid,Transparent';
  }, 'the three OverflowToolbar designs never reached the first list');

  // the status box and the InfoLabel box of the third list
  await waitForUi5(page, () => {
    const os = ui5All().find((c) => c.getMetadata().getName() === 'sap.m.ObjectStatus');
    const il = ui5All().find((c) => c.getMetadata().getName() === 'sap.tnt.InfoLabel');
    return os && il && os.getText() === 'Positive Status' && os.getState() === 'Success'
      && il.getText() === 'T-Shirt Size M' && il.getColorScheme() === 4;
  }, 'the ObjectStatus / InfoLabel head lines never rendered');

  // every icon-only button carries the tooltip the port adds
  await waitForUi5(page, () => {
    const btns = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Button' && !c.getText());
    return btns.length === 12 && btns.every((b) => !!b.getTooltip());
  }, 'the twelve icon-only buttons never all carried a tooltip');
};
