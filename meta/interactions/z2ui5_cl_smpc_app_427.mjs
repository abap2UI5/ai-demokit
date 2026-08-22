// the Slider value -> Carousel width expression binding (roundtrip-free)
import { sliderDrivenWidth } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  // one ArrowLeft on the slider moves the bound percentage from 100 to 99 and
  // the Carousel width expression has to follow it
  await sliderDrivenWidth(page, 'sap.m.Carousel');
};
