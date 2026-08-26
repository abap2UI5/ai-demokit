// FileUploader: the Upload File press really calls upload( ), and the
// uploadComplete wire raises the sample's hardcoded success toast.
//
// TWO things this module has to carry.
//
// 1. The toast text changed with the port. Until 2026-08-23 the press raised
//    an INVENTED 'Uploading file to the local server ...' toast (nothing
//    called upload( ), so uploadComplete was unreachable); the port now wires
//    the press to `control_by_id fileUploader upload`, exactly what
//    handleUploadPress does, and the only toast left is the uploadComplete
//    one the original hardcodes. This module still asserted the removed text
//    (it was written 2026-08-04, for the old port).
//
// 2. The harness cannot serve the sample's uploadUrl, and cannot be given an
//    endpoint that serves it: abap2UI5's express shim routes EVERY path into
//    the ICF handler (`app.all("/{*path}")` -> cl_express_icf_shim ->
//    ZCL_SICF), which parses any POST body as abap2UI5 JSON. The
//    FileUploader's multipart form POST to uploadUrl="upload/" therefore
//    answers `Json parsing error: Not JSON` inside a 500, and e2e-smoke's
//    response listener books every localhost:3000 >= 400 against the port
//    (nightly 2026-08-25: `backend HTTP 500 for /upload/`). The original's
//    `upload/` is a demo kit placeholder no server behind these samples
//    implements either - the sidecar says the upload CYCLE is out of scope -
//    so the ENDPOINT is stubbed here. Nothing of the port is bypassed: the
//    press, the control_by_id upload( ), the real form POST and the real
//    uploadComplete event all run; only the server that would answer them is
//    supplied, and the route flag proves the POST was actually made.
//    (Sibling port 246 makes the same POST, but its interaction drives the
//    empty-value branch, so it never reaches upload( ) and never hit this.)
export default async (page, expect) => {
  let posted = false;
  await page.route(
    (url) => url.hostname === 'localhost' && url.port === '3000' && url.pathname === '/upload/',
    (route) => {
      if (route.request().method() === 'POST') posted = true;
      // the body is what handleUploadComplete would have parsed; the port
      // toasts the hardcoded text either way, as the original does
      return route.fulfill({ status: 200, contentType: 'text/plain', body: 'File upload complete. Status: 200' });
    },
  );
  const btn = page.getByRole('button', { name: 'Upload File', exact: true }).first();
  await expect(btn, 'the Upload File button').toBeVisibleEnabled();
  await btn.click();
  await expect(page.locator('.sapMMessageToast'), 'the uploadComplete client toast')
    .toContainText('File upload complete. Status: 200 (Upload Success)');
  if (!posted) {
    throw new Error('the Upload File press never POSTed to uploadUrl "upload/" — control_by_id upload( ) did not reach the control');
  }
};
