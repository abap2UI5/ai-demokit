// The port's only wire: the breadcrumb Link press round-trips LINK2_PRESS and
// the server answers with the controller's constant-text MessageToast. The
// breadcrumbs fold into a Select at this viewport, which pressBreadcrumb takes
// care of. The subtitle is asserted alongside it because it is what identifies
// THIS port among the four that share the same Denise Smith header.
import { pressBreadcrumb } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the header identifier').toContainText('Denise Smith');
  await expect(page.locator('.sapUxAPObjectPageHeaderTitle'), 'the child-page subtitle')
    .toContainText('Example of a child page in ObjectPage terms');

  await pressBreadcrumb(page, 'Page 2 long link');
  await expect(page.locator('.sapMMessageToast').last(), 'the LINK2_PRESS toast')
    .toContainText('Page 2 long link clicked');
};
