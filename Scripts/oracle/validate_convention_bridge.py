"""
validate_convention_bridge.py
------------------------------
Computes and verifies the Baez (2002) to project-XOR octonion convention bridge.

Establishes the unique (up to canonical choice) permutation and sign-correction
vector mapping Baez's mod-7 octonion convention to the project XOR convention.

Results:
  Permutation (Baez index -> XOR decimal index):
    0->0, 1->1, 2->2, 3->6, 4->3, 5->4, 6->5, 7->7
  Sign corrections (canonical choice s1=s2=s3=+1):
    Only Baez e5 -> -e100 requires a sign flip; all others are +1.

Furey ladder operators translated to XOR convention:
  alpha_1 (Baez: (-e5 + i*e4)/2) -> (+e100 + i*e011) / 2
  alpha_2 (Baez: (-e3 + i*e1)/2) -> (-e110 + i*e001) / 2
  alpha_3 (Baez: (-e6 + i*e2)/2) -> (-e101 + i*e010) / 2

Tool: Python 3.x (no dependencies)
License: project (Apache-2.0)
"""

TRIPLES_XOR  = [(1,2,3),(1,5,4),(1,6,7),(2,4,6),(2,5,7),(3,5,6),(3,7,4)]
TRIPLES_BAEZ = [(1,2,4),(2,3,5),(3,4,6),(4,5,7),(5,6,1),(6,7,2),(7,1,3)]

# Canonical label permutation: Baez index -> XOR decimal index
PI = {0:0, 1:1, 2:2, 3:6, 4:3, 5:4, 6:5, 7:7}


def build_table(triples):
    t = {}
    for i in range(8): t[(0,i)]=(1,i); t[(i,0)]=(1,i)
    for i in range(1,8): t[(i,i)]=(-1,0)
    for a,b,c in triples:
        for x,y,z in [(a,b,c),(b,c,a),(c,a,b)]:
            t[(x,y)]=(1,z); t[(y,x)]=(-1,z)
    return t


def b(n):
    return f"e{bin(n)[2:].zfill(3)}"


def solve_signs(canonical_s1=1, canonical_s2=1, canonical_s3=1):
    """Solve for sign corrections given three free choices."""
    tXOR = build_table(TRIPLES_XOR)
    s = {0:1, 1:canonical_s1, 2:canonical_s2, 3:canonical_s3}
    for (a,b_,c) in TRIPLES_BAEZ:
        pa, pb, pc = PI[a], PI[b_], PI[c]
        sg, _ = tXOR[(pa, pb)]
        if a in s and b_ in s: s[c] = s[a] * s[b_] * sg
    return s


def verify_bridge(s):
    tXOR = build_table(TRIPLES_XOR)
    failures = []
    for (a, b_, c) in TRIPLES_BAEZ:
        for (x, y, z) in [(a,b_,c),(b_,c,a),(c,a,b_)]:
            pa, py, pz = PI[x], PI[y], PI[z]
            sg, idx = tXOR[(pa, py)]
            if s[x]*s[y]*sg != s[z] or idx != pz:
                failures.append(f"FAIL ({x},{y},{z}): "
                                 f"sign {s[x]*s[y]*sg} != {s[z]}, idx {idx} != {pz}")
        for (x, y, z) in [(a,b_,c),(b_,c,a),(c,a,b_)]:
            pa, py, pz = PI[x], PI[y], PI[z]
            sg_rev, _ = tXOR[(py, pa)]
            if s[y]*s[x]*sg_rev != -s[z]:
                failures.append(f"FAIL rev ({x},{y},{z})")
    return failures


if __name__ == "__main__":
    print("=== PhysicsSM Baez->XOR convention bridge validator ===\n")

    s = solve_signs()

    print("Sign vector (canonical choice s1=s2=s3=+1):")
    for i in range(1, 8):
        xi = PI[i]
        flip = "  <- sign flip!" if s[i] == -1 else ""
        print(f"  Baez e{i} -> {s[i]:+d} * {b(xi)}{flip}")

    print()
    failures = verify_bridge(s)
    if failures:
        print(f"[FAIL] {len(failures)} verification failures:")
        for f_ in failures: print(f"  {f_}")
    else:
        print("[PASS] All 42 forward+reversed products verified.")

    print()
    print("Furey ladder operators in XOR convention:")
    print("(Furey, EPJC 2018, arXiv:1806.00612)")
    furey = [("alpha_1", 5, 4), ("alpha_2", 3, 1), ("alpha_3", 6, 2)]
    for name, fi, fj in furey:
        xi, xj = PI[fi], PI[fj]
        si, sj = s[fi], s[fj]
        c_re = -si   # coefficient of e_xi
        c_im =  sj   # coefficient of i*e_xj
        re_s = f"{'+' if c_re > 0 else ''}{c_re}*{b(xi)}"
        im_s = f"{'+' if c_im > 0 else ''}{c_im}*i*{b(xj)}"
        print(f"  {name} (Baez: (-e{fi} + i*e{fj})/2)")
        print(f"         (XOR:  ({re_s} {im_s}) / 2)")
