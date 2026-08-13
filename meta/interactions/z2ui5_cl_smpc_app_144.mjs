// the "controller sets a width from a slider" class — 144 keeps the
// round-trip (the bound width is composed in ABAP), 176/213/214 dissolve it
// into an expression binding; all four must end at 99 % after one key press
import { sliderDrivenWidth } from '../../scripts/lib-e2e.mjs';

export default (page) => sliderDrivenWidth(page, 'sap.m.Panel');
