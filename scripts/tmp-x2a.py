#!/usr/bin/env python3
"""Throwaway XML view -> z2ui5_cl_ai_xml builder chain.

Mechanical first draft only: it copies controls, namespaces and literal
attribute values 1:1. Every binding, event wire and model decision is still
made by hand on the output.

usage: tmp-x2a.py <view.xml> [indent]
"""
import sys
from xml.dom import minidom

MAXLEN = 250


def lit(value):
    return value.replace('`', '``')


def emit_attr(out, indent, name, value, width):
    pad = ' ' * indent
    head = f"{pad})->a( n = `{name}`{' ' * (width - len(name))} v = "
    cont = ' ' * len(head)
    room = MAXLEN - len(head) - 4
    rest = lit(value)
    parts = []
    while len(rest) > room:
        cut = rest.rfind(' ', 0, room) + 1
        if cut <= 0:
            cut = room
        parts.append(rest[:cut])
        rest = rest[cut:]
    parts.append(rest)
    for i, p in enumerate(parts):
        prefix = head if i == 0 else cont
        tail = ' &&' if i < len(parts) - 1 else ''
        out.append(f"{prefix}`{p}`{tail}")


def elements(node):
    return [c for c in node.childNodes if c.nodeType == c.ELEMENT_NODE]


def walk(node, out, indent, root=False):
    name = node.tagName
    ns, _, local = name.rpartition(':')
    kids = elements(node)
    attrs = [(node.attributes.item(i).name, node.attributes.item(i).value)
             for i in range(node.attributes.length)]
    verb = 'open' if kids else 'leaf'
    pad = ' ' * indent
    call = f"{pad})->{verb}( n = `{local}` ns = `{ns}`" if ns else f"{pad})->{verb}( `{local}`"
    if root:
        call = f"{pad}view->{verb}( n = `{local}` ns = `{ns}`"
    out.append(call)
    if attrs:
        width = max(len(a[0]) for a in attrs)
        for k, v in attrs:
            emit_attr(out, indent + 4, k, v, width)
    for i, kid in enumerate(kids):
        if attrs or i > 0:
            out.append('')
        walk(kid, out, indent + 4)
    if kids:
        out.append('')
        out.append(f"{pad})->shut(")


def main(path, indent=4):
    doc = minidom.parse(path)
    root = next(n for n in doc.childNodes if n.nodeType == n.ELEMENT_NODE)
    out = []
    walk(root, out, indent, root=True)
    # drop the trailing shut chain back to the root and close the statement
    while out and out[-1].strip() in ('', ')->shut('):
        if out[-1].strip() == ')->shut(' and out[-1].startswith(' ' * indent + ')'):
            break
        out.pop()
    out[-1] = out[-1] + ' ).' if out[-1].strip().endswith('(') else out[-1] + ' ).'
    print('\n'.join(out))


if __name__ == '__main__':
    main(sys.argv[1], int(sys.argv[2]) if len(sys.argv) > 2 else 4)
