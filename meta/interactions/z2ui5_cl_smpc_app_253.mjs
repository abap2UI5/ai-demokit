// bound valueState / valueStateText over a 5-row aggregation: each state
// must reach the DOM exactly once (render-smoke only sees the mocked model).
// One generic assertion, shared by the three value-state pickers.
import { valueStateRows } from '../../scripts/lib-e2e.mjs';

export default (page, expect) => valueStateRows(page, expect, 'DatePicker');
