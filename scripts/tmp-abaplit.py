#!/usr/bin/env python3
"""Throwaway helper: emit a long text as a `&&`-split ABAP backtick literal chain
for one `)->a( n = <attr> v = ... )` line at a given indent."""
import sys


def emit(text, indent, attr, maxlen=250):
    pad = ' ' * indent
    head = f"{pad})->a( n = `{attr}` v = "
    cont = ' ' * len(head)
    parts, rest = [], text.replace('`', '``')
    room = maxlen - len(head) - 4
    while len(rest) > room:
        cut = rest.rfind(' ', 0, room) + 1
        if cut <= 0:
            cut = room
        parts.append(rest[:cut])
        rest = rest[cut:]
    parts.append(rest)
    out = []
    for i, p in enumerate(parts):
        prefix = head if i == 0 else cont
        tail = ' &&' if i < len(parts) - 1 else ''
        out.append(f"{prefix}`{p}`{tail}")
    return '\n'.join(out)


if __name__ == '__main__':
    print(emit(open(sys.argv[1]).read().strip(), int(sys.argv[2]), sys.argv[3]))
