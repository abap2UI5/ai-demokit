#!/usr/bin/env python3
"""Throwaway generator: the OData ProductSet mock as an ABAP VALUE block.

usage: tmp-productset.py <var> <field:JsonKey,...> [indent]
"""
import json
import sys

SRC = 'ui5/sap.ui.table/OData/ProductSet.json'


def rows():
    return json.load(open(SRC))['d']['results']


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
    for p in rows():
        parts = [f'{name} = {abap(p.get(src, ""))}' for name, src in fields]
        row = f'{pad}  ( ' + ' '.join(parts) + ' )'
        if len(row) <= 250:
            lines.append(row)
            continue
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
