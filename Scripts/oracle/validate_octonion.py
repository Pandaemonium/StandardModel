"""
validate_octonion.py
--------------------
Validates the project XOR octonion convention.

Checks:
  1. XOR closure: for each positive triple (a, b, c), a XOR b == c.
  2. Fano incidence: exactly 7 lines, each pair of points on exactly 1 line.
  3. Moufang identity: (xy)(zx) == x((yz)x) for all basis elements.

Convention (project XOR basis):
  e000 = unit (index 0)
  e001, e010, e011, e100, e101, e110, e111 = imaginary units (indices 1-7)

Positive triples (eₐ * e_b = e_c, cyclic):
  e001 * e010 = e011
  e001 * e101 = e100
  e001 * e110 = e111
  e010 * e100 = e110
  e010 * e101 = e111
  e011 * e101 = e110
  e011 * e111 = e100   <- user-specified anchor

Tool: Python 3.x (no dependencies)
License: project (Apache-2.0)
"""

from itertools import combinations, product as iproduct

TRIPLES = [
    (0b001, 0b010, 0b011),
    (0b001, 0b101, 0b100),
    (0b001, 0b110, 0b111),
    (0b010, 0b100, 0b110),
    (0b010, 0b101, 0b111),
    (0b011, 0b101, 0b110),
    (0b011, 0b111, 0b100),
]

def b(n):
    return f"e{bin(n)[2:].zfill(3)}"


def check_xor_closure(triples):
    errors = []
    for a, b_, c in triples:
        if a ^ b_ != c:
            errors.append(f"  XOR closure fails: {b(a)}^{b(b_)} = {b(a^b_)}, expected {b(c)}")
    if errors:
        return False, "XOR closure FAILED:\n" + "\n".join(errors)
    return True, "XOR closure OK"


def check_fano(triples):
    if len(triples) != 7:
        return False, f"Need 7 lines, got {len(triples)}"
    pair_count = {}
    for a, b_, c in triples:
        if len({a, b_, c}) != 3:
            return False, f"Repeated point in ({b(a)}, {b(b_)}, {b(c)})"
        for p in combinations(sorted([a, b_, c]), 2):
            pair_count[p] = pair_count.get(p, 0) + 1
    if len(pair_count) != 21:
        return False, f"Expected 21 distinct pairs, got {len(pair_count)}"
    bad = [p for p, n in pair_count.items() if n != 1]
    if bad:
        return False, f"Repeated/missing pairs: {[tuple(b(x) for x in p) for p in bad]}"
    return True, "Fano incidence OK"


def build_table(triples):
    table = {}
    for i in range(8):
        table[(0, i)] = (1, i)
        table[(i, 0)] = (1, i)
    for i in range(1, 8):
        table[(i, i)] = (-1, 0)
    for a, b_, c in triples:
        for x, y, z in [(a, b_, c), (b_, c, a), (c, a, b_)]:
            if (x, y) in table:
                raise ValueError(f"Conflicting product for {b(x)} * {b(y)}")
            table[(x, y)] = (1, z)
            table[(y, x)] = (-1, z)
    if len(table) != 64:
        raise ValueError(f"Incomplete table: {len(table)}/64")
    return table


def mul(t1, t2, table):
    s1, i = t1
    s2, j = t2
    s3, k = table[(i, j)]
    return (s1 * s2 * s3, k)


def check_moufang(table):
    failures = []
    for x, y, z in iproduct(range(8), repeat=3):
        left = mul(table[(x, y)], table[(z, x)], table)
        right = mul(mul((1, x), table[(y, z)], table), (1, x), table)
        if left != right:
            failures.append(f"  x={b(x)}, y={b(y)}, z={b(z)}: {left} != {right}")
    if failures:
        return False, f"Moufang FAILED ({len(failures)} cases):\n" + "\n".join(failures[:5])
    return True, f"Moufang OK (all {8**3} cases)"


def print_table(table):
    print("\nMultiplication table (rows = left factor, cols = right factor):")
    header = "     " + "  ".join(b(j) for j in range(8))
    print(header)
    for i in range(8):
        row = b(i) + " "
        for j in range(8):
            s, k = table[(i, j)]
            row += f" {'+' if s == 1 else '-'}{b(k)}"
        print(row)


if __name__ == "__main__":
    print("=== PhysicsSM XOR octonion convention validator ===\n")

    ok, msg = check_xor_closure(TRIPLES)
    print(f"[{'PASS' if ok else 'FAIL'}] {msg}")

    ok, msg = check_fano(TRIPLES)
    print(f"[{'PASS' if ok else 'FAIL'}] {msg}")

    try:
        table = build_table(TRIPLES)
        ok, msg = check_moufang(table)
        print(f"[{'PASS' if ok else 'FAIL'}] {msg}")
        print_table(table)
    except ValueError as e:
        print(f"[FAIL] Table construction error: {e}")
