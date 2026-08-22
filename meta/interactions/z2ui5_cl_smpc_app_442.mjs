// the two source-switch round-trips writing the bound PDFViewer source
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

const sources = () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.PDFViewer').map((c) => c.getSource());

export default async (page, expect) => {
  const bad = page.getByRole('button', { name: 'Loading Error' }).first();
  await expect(bad, 'the "Loading Error" button').toBeVisibleEnabled();
  await bad.click();
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.PDFViewer')
    .every((c) => (c.getSource() || '').includes('sample_nonexisting.pdf')),
    'the round-trip never wrote the invalid path into both bound PDFViewer sources');
  const good = page.getByRole('button', { name: 'Correctly Displayed' }).first();
  await good.click();
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.PDFViewer')
    .every((c) => (c.getSource() || '').endsWith('/sample.pdf')),
    'the round-trip never wrote the valid path back');
};
