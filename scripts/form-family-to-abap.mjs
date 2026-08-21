/* form-family-to-abap.mjs — rebuild one sample of the sap.ui.layout
 * Form/SimpleForm display-vs-change family as a port class.
 *
 *   node scripts/form-family-to-abap.mjs <ui5/sap.ui.layout/Sample> \
 *        <class> <sample id> <out .clas.abap>
 *
 * The 26 samples of that family (Form354*, Form471, Form480*, Form_Column_*,
 * SimpleForm*) share ALMOST one Page.controller.js: a Page whose content the
 * controller swaps between Display.fragment.xml and Change.fragment.xml, three
 * header Buttons, and bindElement('/SupplierCollection/0'). Only the fragment
 * bodies differ — with ONE exception the emitter has to read the controller
 * for. So the port shape is fixed (apps 312..337) and this emitter produces
 * it: both fragments inlined and switched by the two-way bound
 * edit_mode flag, the row-0 fields seeded at the model root and bound
 * ABSOLUTELY, the Edit/Save/Cancel round-trips with a server-side clone.
 *
 * It is a NARROW tool, not a general XML->builder converter: it knows this
 * family's controller, its supplier fields and its event names, and it throws
 * on anything it does not recognise (an unknown {Field}, a missing header
 * Button, no Page id="page") rather than guessing.
 *
 * Regenerating apps 312..337 reproduces the committed classes BYTE FOR BYTE,
 * below their two generated header lines. Re-check that after touching this
 * file — it is the only thing that keeps the claim true, and it was NOT true
 * between 2026-08-16 and 2026-08-21: four corpus-wide sweeps had moved the
 * ports on without this emitter (`ele`/`tag` replaced `open`/`leaf`,
 * `get_event( )` replaced `get( )-event`, `check_on_navigated( )` became
 * unconditional, `view_model_update( )` went away), so it emitted builder
 * methods that do not exist and the "regenerating is safe" line here and in
 * AGENTS.md pointed at a class that could not activate.
 *
 * The two header lines are NOT emitted here: `npm run keywords` and
 * `npm run summary` write them from meta/<class>.json and the built controls.
 * Regenerate, put those two lines back on top, then run them.
 *
 * Not part of `npm run gates`; the generated file is reviewed and committed
 * like any hand-written port, and its sidecar is written by hand.
 */
import fs from 'node:fs';
import path from 'node:path';

// ---------- minimal XML parser (these fragments have no text nodes) ----------
function parseXml(src) {
  src = src.replace(/<!--[\s\S]*?-->/g, '').replace(/<\?[\s\S]*?\?>/g, '');
  const re = /<(\/?)([A-Za-z0-9_.:]+)((?:\s+[A-Za-z0-9_.:-]+\s*=\s*"[^"]*")*)\s*(\/?)>/g;
  const root = { children: [] };
  const stack = [root];
  let m;
  while ((m = re.exec(src))) {
    const [, close, name, attrsRaw, selfClose] = m;
    if (close) { stack.pop(); continue; }
    const attrs = [];
    const ar = /([A-Za-z0-9_.:-]+)\s*=\s*"([^"]*)"/g;
    let a;
    while ((a = ar.exec(attrsRaw))) attrs.push([a[1], a[2]]);
    const node = { name, attrs, children: [] };
    stack[stack.length - 1].children.push(node);
    if (!selfClose) stack.push(node);
  }
  return root.children[0];
}

// ---------- model fields the supplier record carries ----------
const FIELDS = {
  SupplierName: 'suppliername', Street: 'street', HouseNumber: 'housenumber',
  ZIPCode: 'zipcode', City: 'city', Country: 'country', Url: 'url', Twitter: 'twitter',
  Tel: 'tel', Sms: 'sms', Mobile: 'mobile', Pager: 'pager', Fax: 'fax',
  // the fragments spell it {EMail}; the mock key is Email (see the sidecar note)
  Email: 'email', EMail: 'email',
  Rating: 'rating', Disposable: 'disposable',
};
const EVENTS = {
  '.handleEditPress': 'EDIT', '.handleSavePress': 'SAVE', '.handleCancelPress': 'CANCEL',
};

const usedFields = new Set();

function bindOf(field) {
  const abap = FIELDS[field];
  if (!abap) throw new Error(`unknown model field {${field}}`);
  usedFields.add(abap);
  return `client->_bind( ${abap} )`;
}

/** attribute value -> ABAP expression */
function valueExpr(name, raw) {
  if (name === 'press' && EVENTS[raw]) return { code: 'client->_event( `' + EVENTS[raw] + '` )' };
  const parts = raw.match(/\{[^}]+\}/g);
  if (!parts) return { code: '`' + raw + '`' };
  if (parts.length === 1 && parts[0] === raw) return { code: bindOf(raw.slice(1, -1)) };
  // composite: keep the literal text, interpolate every binding
  let out = raw.replace(/\{([^}]+)\}/g, (_, f) => '{ ' + bindOf(f) + ' }');
  return { code: '|' + out + '|' };
}

// ---------- emitter ----------
const IND = (lvl) => ' '.repeat(4 + 4 * lvl);

function controlLine(node, lvl) {
  const [pfx, local] = node.name.includes(':') ? node.name.split(':') : [null, node.name];
  const verb = node.children.length ? 'ele' : 'tag';
  const args = pfx ? '( n = `' + local + '` ns = `' + pfx + '`' : '( `' + local + '`';
  return { text: IND(lvl) + ')->' + verb + args, verb, isAggregation: /^[a-z]/.test(local) };
}

// `attrComment` maps an attribute name to the comment lines that belong ABOVE
// it. A note about one attribute reads as a note about the whole control when
// it sits above the tag, which is where this emitter used to put it.
function attrLines(attrs, lvl, attrComment) {
  if (!attrs.length) return [];
  const w = Math.max(...attrs.map(([n]) => n.length));
  const exprs = attrs.map(([n, v]) => [n, valueExpr(n, v).code]);
  const out = [];
  for (const [n, code] of exprs) {
    for (const c of (attrComment && attrComment[n]) || []) out.push(IND(lvl) + '    " ' + c);
    out.push(IND(lvl) + '    )->a( n = `' + n + '`' + ' '.repeat(w - n.length) + ' v = ' + code);
  }
  return out;
}

/** emit one node; `out` collects lines. Returns nothing. */
function emit(node, lvl, out, prevSiblingVerb) {
  const cl = controlLine(node, lvl);
  const attrs = attrLines(node.attrs, lvl, node.attrComment);
  // a blank separates a new block from a previous TAG sibling; never after a
  // shut, never between consecutive tags
  if (out.length && prevSiblingVerb === 'tag' && node.children.length) out.push('');
  if (node.comment) out.push(IND(lvl) + '" ' + node.comment);
  out.push(cl.text);
  out.push(...attrs);
  if (cl.verb === 'tag') return 'tag';
  // blank line between an open WITH attrs and its first child
  if (attrs.length && node.children.length) out.push('');
  let prev = null;
  for (const child of node.children) {
    // a commented child opens a block of its own; let it breathe
    if (child.comment && out.length && out[out.length - 1] !== '') out.push('');
    emit(child, lvl + 1, out, prev);
    prev = child.children.length ? 'ele' : 'tag';
  }
  if (out[out.length - 1].trim() !== ')->end(') out.push('');
  out.push(IND(lvl) + ')->end(');
  return 'ele';
}

function emitView(viewNode) {
  const out = [];
  const cl = controlLine(viewNode, 0);
  out.push('    view->' + cl.text.trimStart().replace(/^\)->/, ''));
  out.push(...attrLines(viewNode.attrs, 0, viewNode.attrComment));
  let prev = null;
  for (const child of viewNode.children) {
    out.push('');
    emit(child, 1, out, prev);
    prev = child.children.length ? 'ele' : 'tag';
  }
  // drop the trailing shut chain and close the statement
  while (out.length && (out[out.length - 1].trim() === ')->end(' || out[out.length - 1] === '')) out.pop();
  out[out.length - 1] += ' ).';
  return out;
}

// ---------- port assembly ----------
const VISIBLE_DISPLAY = '|\\{= !${ client->_bind( edit_mode ) }\\}|';
const VISIBLE_CHANGE = 'client->_bind( edit_mode )';

function build(sampleDir, cls) {
  usedFields.clear();
  const rd = (f) => fs.readFileSync(path.join(sampleDir, f), 'utf8');
  const pageView = parseXml(rd('Page.view.xml'));
  const display = parseXml(rd('Display.fragment.xml')).children[0]; // the VBox
  const change = parseXml(rd('Change.fragment.xml')).children[0];

  // the port view root: the sample's mvc:View attrs minus controllerName, plus
  // the namespaces the inlined fragments need
  const rootAttrs = pageView.attrs.filter(([n]) => n !== 'controllerName' && !n.startsWith('xmlns'));
  const ns = [['xmlns:mvc', 'sap.ui.core.mvc'], ['xmlns', 'sap.m'],
    ['xmlns:l', 'sap.ui.layout'], ['xmlns:f', 'sap.ui.layout.form'], ['xmlns:core', 'sap.ui.core']];
  const view = { name: 'mvc:View', attrs: [...rootAttrs, ...ns], children: pageView.children.map(clone) };

  // wire the three header buttons and inject the visibility flag
  let seen = 0;
  walk(view, (n) => {
    if (n.name !== 'Button') return;
    const id = (n.attrs.find(([a]) => a === 'id') || [])[1];
    if (!['edit', 'save', 'cancel'].includes(id)) return;
    seen++;
    const hadEnabled = n.attrs.some(([a]) => a === 'enabled');
    n.attrs = n.attrs.filter(([a]) => a !== 'visible' && a !== 'enabled');
    if (id === 'edit' && hadEnabled) {
      n.attrs.push(['enabled', 'true']);
      n.attrComment = { enabled: ['the original enables Edit once the mock request completes;',
                                  'the ABAP model is seeded synchronously, so it starts enabled'] };
    }
    n.attrs.push(['visible', id === 'edit' ? ' D' : ' C']);
    // keep press last so it reads like the original
    const press = n.attrs.find(([a]) => a === 'press');
    n.attrs = n.attrs.filter(([a]) => a !== 'press').concat([press]);
  });
  if (seen !== 3) throw new Error(`${cls}: found ${seen} header buttons, expected 3`);

  // the Page (or detail Page) that the controller fills gets both fragments
  const page = find(view, (n) => n.name === 'Page' && (n.attrs.find(([a]) => a === 'id') || [])[1] === 'page');
  if (!page) throw new Error(`${cls}: no Page id="page"`);
  display.attrs.push(['visible', ' D']);
  change.attrs.push(['visible', ' C']);
  display.comment = 'Display.fragment.xml';
  change.comment = 'Change.fragment.xml';
  page.children.push({ name: 'content', attrs: [], children: [display, change] });

  const body = emitView(view)
    .map((l) => l.replace('` D`', VISIBLE_DISPLAY).replace('` C`', VISIBLE_CHANGE));

  const fields = [...new Set(Object.values(FIELDS))].filter((f) => usedFields.has(f));
  return { body, fields };
}

const clone = (n) => ({ name: n.name, attrs: n.attrs.map((a) => a.slice()), children: n.children.map(clone) });
function walk(n, fn) { fn(n); n.children.forEach((c) => walk(c, fn)); }
function find(n, fn) { if (fn(n)) return n; for (const c of n.children) { const r = find(c, fn); if (r) return r; } return null; }

const SUPPLIER = {
  suppliername: ['string', '`Red Point Stores`'], street: ['string', '`Main St`'],
  housenumber: ['string', '`1618`'], zipcode: ['string', '`31415`'],
  city: ['string', '`Maintown`'], country: ['string', '`Germany`'],
  url: ['string', '`http://www.sap.com`'], twitter: ['string', '`@sap`'],
  tel: ['string', '`+49 6227 747474`'], sms: ['string', '`+49 173 123456`'],
  mobile: ['string', '`+49 173 123456`'], pager: ['string', '`+49 173 123456`'],
  fax: ['string', '`+49 123 456789`'], email: ['string', '`john.smith@sap.com`'],
  // numeric properties (RatingIndicator.value, ProgressIndicator.percentValue):
  // typed numerically so the model carries a real JSON number
  rating: ['i', '4'], disposable: ['i', '30'],
};
const TYPEOF = (f) => SUPPLIER[f][0];
const SEEDOF = (f) => SUPPLIER[f][1];

function render(cls, sample, body, fields, initExtra) {
  const w = Math.max(...fields.map((f) => f.length));
  const pad = (f) => f + ' '.repeat(w - f.length);
  const pub = fields.map((f) => `    DATA ${pad(f)} TYPE ${TYPEOF(f)}.`).join('\n');
  const bw = w + 7;
  const bak = fields.map((f) => `    DATA ${('backup_' + f).padEnd(bw)} TYPE ${TYPEOF(f)}.`).join('\n');
  const save = fields.map((f) => `        ${('backup_' + f).padEnd(bw)} = ${f}.`).join('\n');
  const rest = fields.map((f) => `        ${pad(f)} = backup_${f}.`).join('\n');
  const seed = fields.map((f) => `    ${pad(f)} = ${SEEDOF(f)}.`).join('\n');
  return `CLASS ${cls} DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ${pad('edit_mode')} TYPE abap_bool.
${pub}

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " handleEditPress clones the record so Cancel can restore it - the clone is
    " not bound, so it stays out of the round-trip model scan
${bak}

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS ${cls} IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).${initExtra}
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " _showFormFragment swaps the Page content between the Display and the Change
    " fragment; both are inlined here and switched by one bound flag instead
${body.join('\n')}

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN \`EDIT\`.
        " handleEditPress: clone the record, then show the Change form and the
        " Save/Cancel buttons
${save}
        ${'edit_mode'.padEnd(bw)} = abap_true.

      WHEN \`SAVE\`.
        " handleSavePress: keep the edited values, back to the Display form
        edit_mode = abap_false.

      WHEN \`CANCEL\`.
        " handleCancelPress: restore the cloned record, back to the Display form
${rest}
        ${pad('edit_mode')} = abap_false.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the original binds /SupplierCollection/0 of the shared demo supplier.json;
    " flattened here to top-level fields the form binds absolutely
${seed}

  ENDMETHOD.

ENDCLASS.
`;
}

/* The ONE piece of per-sample controller variance in the family. Two of the 26
 * — Form471 and SimpleForm471 — end onInit with
 *
 *     oSplitContainer.toDetail(this.createId("page"));
 *
 * commented "to navigate to the page on phone and not show the split screen
 * items". initialDetail names the detail page but does not put a PHONE into
 * detail mode, so without the call a phone opens on the master list where the
 * sample opens on the form.
 *
 * This emitter used to claim it "knows this family's controller" while never
 * opening Page.controller.js, so the call was invisible to it — and to
 * structural-diff, which compares views only. Both ports had silently lost the
 * behaviour (found by review 2026-08-21). Read the controller, and throw rather
 * than guess if it says something this emitter does not model. */
function initExtraFrom(sampleDir) {
  const f = path.join(sampleDir, 'Page.controller.js');
  if (!fs.existsSync(f)) throw new Error(`${sampleDir}: no Page.controller.js`);
  const src = fs.readFileSync(f, 'utf8');
  const m = src.match(/(\w+)\.toDetail\(this\.createId\("(\w+)"\)\)/);
  if (!m) return '';
  const id = (src.match(new RegExp(`${m[1]}\\s*=\\s*this\\.byId\\("(\\w+)"\\)`)) || [])[1];
  if (!id) throw new Error(`${sampleDir}: toDetail( ) on a SplitContainer this emitter cannot name`);
  return `
      " onInit ends with oSplitContainer.toDetail( this.createId('${m[2]}') ) -
      " "to navigate to the page on phone and not show the split screen items".
      " initialDetail names the detail page but does not put a PHONE into detail
      " mode, so without this a phone opens on the master list where the sample
      " opens on the form. toDetail is a listed control method taking a
      " controlId, so the wire carries it as-is.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( \`${id}\` ) ( \`toDetail\` ) ( \`${m[2]}\` ) ) ).`;
}

// ---------- CLI ----------
const [, , sampleDir, cls, sample, outFile] = process.argv;
const { body, fields } = build(sampleDir, cls);
fs.writeFileSync(outFile, render(cls, sample, body, fields, initExtraFrom(sampleDir)));
console.log(`${cls}  <- ${path.basename(sampleDir)}  (${fields.length} fields)`);
