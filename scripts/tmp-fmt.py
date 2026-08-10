#!/usr/bin/env python3
"""Throwaway formatter for generated view chains.

Applies the corpus formatting rules to a `.clas.abap` port:
  * align the `v =` column across a control's consecutive `)->a( … )` lines
  * no blank line after an `open( )` that carries no attributes
  * a blank line between an attribute-carrying `open( )` and its first child
  * a blank line before every `)->shut(`, none between/after `shut`s
"""
import re
import sys

A_RE = re.compile(r'^(\s*)\)->a\( n = (`[^`]+`|\|[^|]*\|)\s+v = (.*)$')
OPEN_RE = re.compile(r'^(\s*)\)?->?open\(')
SHUT_RE = re.compile(r'^(\s*)\)->shut\(')
CHAIN_RE = re.compile(r'^\s*\)->')


def is_cont(line):
    """a continuation line of a multi-line attribute value"""
    return line.strip() != '' and not CHAIN_RE.match(line) and not line.lstrip().startswith('view->')


def align(lines):
    out = []
    i = 0
    while i < len(lines):
        m = A_RE.match(lines[i])
        if not m:
            out.append(lines[i])
            i += 1
            continue
        # collect the group of consecutive )->a( lines with the same indent
        indent = m.group(1)
        group = []
        j = i
        while j < len(lines):
            mm = A_RE.match(lines[j])
            if not mm or mm.group(1) != indent:
                break
            entry = [lines[j]]
            j += 1
            while j < len(lines) and is_cont(lines[j]):
                entry.append(lines[j])
                j += 1
            group.append((mm, entry))
        width = max(len(g[0].group(2)) for g in group)
        for mm, entry in group:
            name = mm.group(2)
            head = f"{indent})->a( n = {name}{' ' * (width - len(name))} v = "
            old_head_len = len(lines[0]) - len(lines[0])  # placeholder
            old = entry[0]
            old_prefix_len = old.index(' v = ') + len(' v = ')
            delta = len(head) - old_prefix_len
            out.append(head + mm.group(3))
            for cont in entry[1:]:
                stripped = cont.lstrip(' ')
                pad = len(cont) - len(stripped)
                out.append(' ' * max(0, pad + delta) + stripped)
        i = j
    return out


CTRL_RE = re.compile(r'^\s*\)?->?(open|leaf)\(')


def blanks(lines):
    out = []
    for idx, line in enumerate(lines):
        s = line.strip()
        nxt = next((l for l in lines[idx + 1:] if l.strip() != ''), '')
        if s == '' and out:
            prev = out[-1]
            # no blank between a control and its own attributes
            if CTRL_RE.match(prev) and A_RE.match(nxt):
                continue
            # no blank after an open( ) that carries no attributes
            if OPEN_RE.match(prev) and not A_RE.match(nxt):
                continue
            # no blank after / between shut( )s, while still inside the chain
            if SHUT_RE.match(prev) and CHAIN_RE.match(nxt):
                continue
        out.append(line)
    # a blank line before every shut that follows an attribute or a leaf
    res = []
    for line in out:
        if SHUT_RE.match(line) and res and res[-1].strip() != '' and not SHUT_RE.match(res[-1]):
            res.append('')
        res.append(line)
    return res


def param_align(lines):
    out = []
    for line in lines:
        st = line.lstrip()
        if st.startswith('t_arg =') and out:
            prev = out[-1]
            k = prev.find(' val   = ')
            if k < 0:
                k = prev.find(' val = ')
            if k >= 0:
                out.append(' ' * (k + 1) + st)
                continue
        out.append(line)
    return out


def main(path):
    lines = open(path).read().split('\n')
    lines = param_align(blanks(align(lines)))
    open(path, 'w').write('\n'.join(lines))


if __name__ == '__main__':
    for p in sys.argv[1:]:
        main(p)
