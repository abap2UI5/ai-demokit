// the two inlined wizards and the linear current-step Select
import { waitForUi5, ui5All } from '../../scripts/lib-e2e.mjs';

export default async (page, expect) => {
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Wizard').length === 2,
    'the two inlined wizards never rendered');
  // the showcase flag makes the linear one visible and the branching one not
  await waitForUi5(page, () => {
    const w = ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.Wizard');
    return w.filter((c) => c.getVisible()).length === 1 && w.find((c) => c.getVisible()).getEnableBranching() === false;
  }, 'the showcase expression never reached the two wizards');
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.WizardStep').length === 13,
    'the 4 linear + 9 branching steps never rendered');
  // the branching wizard is not VISIBLE at boot (the showcase starts linear),
  // so its radio buttons are read off the registry rather than the rendered body
  await waitForUi5(page, () => ui5All().filter((c) => c.getMetadata().getName() === 'sap.m.RadioButton')
    .some((c) => c.getText() === 'A->B1->C->D->E->F1->F2->G'),
    'the three branching path radio buttons never reached the branching wizard');

  // Branching.controller applies path 0 in onAfterRendering, on EVERY render.
  // The two BRANCH points declare only subsequentSteps, never a nextStep, so
  // without that call they sit at null - which is what this port did, because
  // it applied the path only from the RadioButtonGroup's select event and that
  // never fires for the already-selected button 0. Measured before the fix:
  // A:next=NULL and E:next=NULL while every linear step carried its declared
  // nextStep. The linear steps are asserted with them, because path 0
  // (A->B1->C->D->E->F1->F2->G) also RE-POINTS F1 away from its XML default G.
  const wired = await page.evaluate(`(() => {
    const all = Object.values(sap.ui.require('sap/ui/core/Element').registry.all());
    const w = all.find((c) => c.getMetadata().getName() === 'sap.m.Wizard'
      && !c.bIsDestroyed && c.getEnableBranching());
    if (!w) return null;
    const tail = (v) => (v ? String(v).split('--').pop() : null);
    const out = {};
    w.getSteps().forEach((s) => { out[tail(s.getId())] = tail(s.getNextStep()); });
    return out;
  })()`);
  if (!wired) throw new Error('the branching wizard is not in the registry');
  const want = { A: 'B1', B1: 'C', B2: 'C', C: 'D', D: 'E', E: 'F1', F1: 'F2', F2: 'G', G: null };
  for (const [step, next] of Object.entries(want)) {
    if (wired[step] !== next) {
      throw new Error(`step ${step} points at ${JSON.stringify(wired[step])}, not ${JSON.stringify(next)} - path 0 was not applied on render (${JSON.stringify(wired)})`);
    }
  }
};
