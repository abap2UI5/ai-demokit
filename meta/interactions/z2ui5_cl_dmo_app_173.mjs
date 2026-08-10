// the device branch resolved server-side (app 012 precedent): a desktop run
// must seed the else-branch widths, not the phone ones
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page) => {
  await waitForUi5(page, () => {
    const w = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Image').map((c) => c.getWidth());
    return ['5em', '10em', '15em'].every((x) => w.includes(x));
  }, 'the desktop-branch widths (5em/10em/15em) never reached the three Images');
};
