#!/usr/bin/env python3
"""Throwaway generator: the shared demo ProductCollection as an ABAP VALUE block.

The sap.ui.table samples all load sap/ui/demo/mock/products.json and derive four
fields in their controller (DeliveryDate, DeliveryDateStr, Heavy, Available).
The base date matches app 164's anchored 2026-07-23 so the corpus stays
deterministic and consistent.

usage: tmp-products.py <var> <field:src,...> [indent]
  field names are ABAP names, src is the JSON key or a derived key
"""
import datetime
import json
import sys

BASE_MS = 1784764800000          # 2026-07-23, app 164's anchor for Date.now()
DAY_MS = 24 * 60 * 60 * 1000
MOCK = 'ui5/mock/products.json'


def rows():
    data = json.load(open(MOCK))['ProductCollection']
    out = []
    for i, p in enumerate(data):
        p = dict(p)
        ms = BASE_MS - (i % 10) * 4 * DAY_MS
        p['DeliveryDate'] = ms
        p['DeliveryDateStr'] = datetime.datetime.utcfromtimestamp(ms / 1000).strftime('%d/%m/%Y')
        p['Heavy'] = 'true' if p.get('WeightMeasure', 0) > 1000 else 'false'
        p['Available'] = p.get('Status') == 'Available'
        p['AvailableState'] = 'Success' if p['Available'] else 'Error'
        p['AvailableIcon'] = 'sap-icon://accept' if p['Available'] else 'sap-icon://decline'
        if 'ProductPicUrl' in p:
            p['ProductPicUrl'] = 'https://sdk.openui5.org/' + p['ProductPicUrl']
        out.append(p)
    return out


def abap(v):
    if isinstance(v, bool):
        return 'abap_true' if v else 'abap_false'
    if isinstance(v, (int, float)):
        return str(v)
    return '`' + str(v).replace('`', '``') + '`'


def main(var, spec, indent=4):
    fields = [f.split(':') for f in spec.split(',')]
    pad = ' ' * indent
    lines = [f'{pad}{var} = VALUE #(']
    body = []
    for p in rows():
        cells = []
        for name, src in fields:
            cells.append((name, abap(p.get(src, ''))))
        body.append(cells)
    for cells in body:
        parts = [f'{name} = {val}' for name, val in cells]
        row = f'{pad}  ( ' + ' '.join(parts) + ' )'
        if len(row) <= 250:
            lines.append(row)
            continue
        # wrap a long row onto continuation lines, indented under the opening (
        cont = f'{pad}    '
        cur = f'{pad}  ('
        for part in parts:
            if len(cur) + 1 + len(part) > 250:
                lines.append(cur)
                cur = cont + part
            else:
                cur = cur + ' ' + part
        lines.append(cur + ' )')
    lines.append(f'{pad}  ).')
    print('\n'.join(lines))


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 4)
