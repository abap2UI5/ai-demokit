// fieldGroupIds + validateFieldGroup: leaving a group fires the event with
// the group's ids, and the backend classifies it into ITS MessageStrip
export default async (page, expect) => {
  const billing = page.locator('#BillingName input, [id$="BillingName-inner"]').first();
  await expect(billing, 'the BillingName input').toBeVisibleEnabled();
  await billing.click();
  // moving focus into ANOTHER group is what triggers the validation
  const discount = page.locator('#DiscountCode input, [id$="DiscountCode-inner"]').first();
  await expect(discount, 'the DiscountCode input').toBeVisibleEnabled();
  await discount.click();
  await expect(page.locator('body'), 'the classified MessageStrip after the round-trip')
    .toContainText("Group 'Billing Information' Validation:Error");
  await expect(page.locator('.sapMMessageToast').last(), 'the validation toast')
    .toContainText("Validation of field group 'Billing Information' triggered.");
};
