"""Oracle for the 1+1D Feynman checkerboard finite combinatorics.

Validates, by brute-force enumeration, the theorem statements scaffolded in
  PhysicsSM/Draft/CheckerboardSpinorRecursionAristotle.lean
  PhysicsSM/Draft/CheckerboardCornerCountAristotle.lean
against the trusted definitions of PhysicsSM/Spinor/Checkerboard.lean
(mirrored here in Python).

Also validates the Pauli spin-projector identities scaffolded in
  PhysicsSM/Draft/SpinCoherentProjectorAristotle.lean
with random unit vectors.

Conventions mirrored from PhysicsSM.Spinor.Checkerboard:
- a history is a list of future steps, each LEFT (-1) or RIGHT (+1);
- the incoming direction d is carried separately; the corner between the
  incoming direction and the first step IS counted and weighted;
- turnWeight(d, e) = 1 if d == e else mu;
- pathWeight(d, h) = product of turnWeight over consecutive pairs of d::h;
- pathSum(mu, x, d, n, y, e) = sum of pathWeight over histories h of length n
  with endpoint(x, h) == y and terminal direction e (terminal = d if h empty).

This is an oracle in the sense of AGENTS.md: it justifies trusting the
*statements* before submitting them as Aristotle proof targets.  It is not a
proof.

Tool: CPython 3.x, stdlib only.
Run:  python Scripts/oracle/validate_checkerboard.py
"""

import itertools
import math
import cmath
import random
from fractions import Fraction

LEFT, RIGHT = -1, 1

# ----------------------------------------------------------------------
# Mirrored definitions
# ----------------------------------------------------------------------

def histories(n):
    return list(itertools.product((LEFT, RIGHT), repeat=n))

def endpoint(x, h):
    return x + sum(h)

def terminal(d, h):
    return h[-1] if h else d

def turn_count(d, h):
    seq = (d,) + tuple(h)
    return sum(1 for a, b in zip(seq, seq[1:]) if a != b)

def path_weight_poly(d, h, nmax):
    """pathWeight as polynomial coefficients in mu: mu^turnCount."""
    coeffs = [0] * (nmax + 1)
    coeffs[turn_count(d, h)] = 1
    return coeffs

def path_sum_poly(x, d, n, y, e):
    """pathSum as polynomial in mu (coefficient list, degree <= n)."""
    coeffs = [0] * (n + 1)
    for h in histories(n):
        if endpoint(x, h) == y and terminal(d, h) == e:
            coeffs[turn_count(d, h)] += 1
    return coeffs

def poly_eval(coeffs, mu):
    return sum(c * mu ** k for k, c in enumerate(coeffs))

def C(n, k):
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)

# ----------------------------------------------------------------------
# 1. Corner-count closed forms (statements for CheckerboardCornerCount)
# ----------------------------------------------------------------------

def turn_histories_count(n, d, dx, e, k):
    return sum(
        1
        for h in histories(n)
        if endpoint(0, h) == dx and terminal(d, h) == e and turn_count(d, h) == k
    )

def check_corner_counts(max_n=11):
    ok = True
    for n in range(0, max_n + 1):
        for p in range(0, n + 1):
            q = n - p
            dx = p - q
            # even turns: start RIGHT, end RIGHT, k = 2r, r >= 1, q >= 1
            for r in range(1, n + 2):
                got = turn_histories_count(n, RIGHT, dx, RIGHT, 2 * r)
                if q >= 1:
                    want = C(p, r) * C(q - 1, r - 1)
                    if got != want:
                        print(f"FAIL even: n={n} p={p} q={q} r={r}: {got} != {want}")
                        ok = False
            # odd turns: start RIGHT, end LEFT, k = 2r+1, q >= 1
            for r in range(0, n + 2):
                got = turn_histories_count(n, RIGHT, dx, LEFT, 2 * r + 1)
                if q >= 1:
                    want = C(p, r) * C(q - 1, r)
                    if got != want:
                        print(f"FAIL odd: n={n} p={p} q={q} r={r}: {got} != {want}")
                        ok = False
            # zero turns, start RIGHT end RIGHT: 1 iff q == 0
            got = turn_histories_count(n, RIGHT, dx, RIGHT, 0)
            want = 1 if q == 0 else 0
            if got != want:
                print(f"FAIL zero: n={n} p={p} q={q}: {got} != {want}")
                ok = False
            # flip symmetry: starting LEFT mirrors starting RIGHT with dx -> -dx
            for e in (LEFT, RIGHT):
                for k in range(0, n + 2):
                    a = turn_histories_count(n, LEFT, dx, e, k)
                    b = turn_histories_count(n, RIGHT, -dx, -e, k)
                    if a != b:
                        print(f"FAIL flip: n={n} dx={dx} e={e} k={k}: {a} != {b}")
                        ok = False
    print("corner-count closed forms:", "OK" if ok else "FAILED")
    return ok

# ----------------------------------------------------------------------
# 2. Last-step recursion and discrete Klein-Gordon (CheckerboardSpinorRecursion)
# ----------------------------------------------------------------------

def check_recursions(max_n=9):
    ok = True
    mus = [Fraction(0), Fraction(1), Fraction(2), Fraction(3), Fraction(-1), Fraction(5, 7)]
    for n in range(0, max_n + 1):
        for d in (LEFT, RIGHT):
            for y in range(-(n + 2), n + 3):
                for e in (LEFT, RIGHT):
                    for mu in mus:
                        # last-step recursion:
                        # pathSum(n+1, y, e) =
                        #   pathSum(n, y - e, e) + pathSum(n, y - e, -e) * mu
                        lhs = poly_eval(path_sum_poly(0, d, n + 1, y, e), mu)
                        rhs = poly_eval(path_sum_poly(0, d, n, y - e, e), mu) \
                            + poly_eval(path_sum_poly(0, d, n, y - e, -e), mu) * mu
                        if lhs != rhs:
                            print(f"FAIL last-step: n={n} d={d} y={y} e={e} mu={mu}")
                            ok = False
                        # discrete Klein-Gordon:
                        # pathSum(n+2, y, e) + pathSum(n, y, e)
                        #   = pathSum(n+1, y-1, e) + pathSum(n+1, y+1, e)
                        #     + mu^2 * pathSum(n, y, e)
                        lhs = poly_eval(path_sum_poly(0, d, n + 2, y, e), mu) \
                            + poly_eval(path_sum_poly(0, d, n, y, e), mu)
                        rhs = poly_eval(path_sum_poly(0, d, n + 1, y - 1, e), mu) \
                            + poly_eval(path_sum_poly(0, d, n + 1, y + 1, e), mu) \
                            + mu * mu * poly_eval(path_sum_poly(0, d, n, y, e), mu)
                        if lhs != rhs:
                            print(f"FAIL KG: n={n} d={d} y={y} e={e} mu={mu}")
                            ok = False
    print("last-step recursion + discrete Klein-Gordon:", "OK" if ok else "FAILED")
    return ok

# ----------------------------------------------------------------------
# 3. Pauli projector identities (SpinCoherentProjector statements)
# ----------------------------------------------------------------------

def mat_mul(A, B):
    return [[sum(A[i][k] * B[k][j] for k in range(2)) for j in range(2)] for i in range(2)]

def mat_add(A, B):
    return [[A[i][j] + B[i][j] for j in range(2)] for i in range(2)]

def mat_scale(c, A):
    return [[c * A[i][j] for j in range(2)] for i in range(2)]

def trace(A):
    return A[0][0] + A[1][1]

ID2 = [[1, 0], [0, 1]]

def pauli_vec(a):
    sx = [[0, 1], [1, 0]]
    sy = [[0, -1j], [1j, 0]]
    sz = [[1, 0], [0, -1]]
    return mat_add(mat_add(mat_scale(a[0], sx), mat_scale(a[1], sy)), mat_scale(a[2], sz))

def projector(a):
    return mat_scale(0.5, mat_add(ID2, pauli_vec(a)))

def dot(a, b):
    return sum(x * y for x, y in zip(a, b))

def cross(a, b):
    return (a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0])

def rand_unit():
    while True:
        v = [random.gauss(0, 1) for _ in range(3)]
        r = math.sqrt(sum(x * x for x in v))
        if r > 1e-6:
            return tuple(x / r for x in v)

def mat_close(A, B, tol=1e-9):
    return all(abs(A[i][j] - B[i][j]) < tol for i in range(2) for j in range(2))

def check_pauli(trials=300):
    ok = True
    random.seed(20260612)
    for _ in range(trials):
        a, b, c = rand_unit(), rand_unit(), rand_unit()
        Pa, Pb, Pc = projector(a), projector(b), projector(c)
        # sigma.a sigma.b = (a.b) 1 + i sigma.(a x b)
        lhs = mat_mul(pauli_vec(a), pauli_vec(b))
        rhs = mat_add(mat_scale(dot(a, b), ID2), mat_scale(1j, pauli_vec(cross(a, b))))
        if not mat_close(lhs, rhs):
            print("FAIL pauli product identity")
            ok = False
        # idempotent
        if not mat_close(mat_mul(Pa, Pa), Pa):
            print("FAIL idempotent")
            ok = False
        # sandwich: Pa Pb Pa = ((1 + a.b)/2) Pa   (needs |a| = 1 only)
        lhs = mat_mul(mat_mul(Pa, Pb), Pa)
        rhs = mat_scale((1 + dot(a, b)) / 2, Pa)
        if not mat_close(lhs, rhs):
            print("FAIL sandwich")
            ok = False
        # Bargmann invariant:
        # tr(Pa Pb Pc) = (1 + a.b + b.c + c.a + i a.(b x c)) / 4
        lhs = trace(mat_mul(mat_mul(Pa, Pb), Pc))
        rhs = (1 + dot(a, b) + dot(b, c) + dot(c, a) + 1j * dot(a, cross(b, c))) / 4
        if abs(lhs - rhs) > 1e-9:
            print("FAIL Bargmann")
            ok = False
        # null 4-vector factorization: minkHerm(r, r*n) = 2r * P(n)
        r = abs(random.gauss(0, 2))
        lhs = mat_add(mat_scale(r, ID2), pauli_vec(tuple(r * x for x in a)))
        rhs = mat_scale(2 * r, Pa)
        if not mat_close(lhs, rhs):
            print("FAIL null factorization")
            ok = False
        # Minkowski determinant: det(p0 + sigma.p) = p0^2 - |p|^2
        p0 = random.gauss(0, 2)
        p = [random.gauss(0, 2) for _ in range(3)]
        M = mat_add(mat_scale(p0, ID2), pauli_vec(p))
        det = M[0][0] * M[1][1] - M[0][1] * M[1][0]
        if abs(det - (p0 ** 2 - dot(p, p))) > 1e-9:
            print("FAIL Minkowski det")
            ok = False
        # rank-one direction: lambda lambda^dagger has det 0 and matches
        # p^mu = (lambda^dag lambda + ..., ...) with p0 >= 0 and p null.
        lam = [complex(random.gauss(0, 1), random.gauss(0, 1)) for _ in range(2)]
        Lmat = [[lam[i] * lam[j].conjugate() for j in range(2)] for i in range(2)]
        det = Lmat[0][0] * Lmat[1][1] - Lmat[0][1] * Lmat[1][0]
        if abs(det) > 1e-9:
            print("FAIL rank-one det")
            ok = False
    print("Pauli projector identities:", "OK" if ok else "FAILED")
    return ok

# ----------------------------------------------------------------------
# 4. Wave-2 statements: general collapse and quaternionic rank-one
#    (SpinCoherentCollapse / SpinorHelicityQuaternion statements)
# ----------------------------------------------------------------------

def qmul(a, b):
    aw, ax, ay, az = a
    bw, bx, by, bz = b
    return (aw * bw - ax * bx - ay * by - az * bz,
            aw * bx + ax * bw + ay * bz - az * by,
            aw * by - ax * bz + ay * bw + az * bx,
            aw * bz + ax * by - ay * bx + az * bw)

def qconj(a):
    return (a[0], -a[1], -a[2], -a[3])

def qnormsq(a):
    return sum(x * x for x in a)

def check_wave2(trials=300):
    ok = True
    random.seed(20260612)
    for _ in range(trials):
        # general collapse: P(a) M P(a) = tr(P(a) M) P(a), arbitrary M, unit a
        a = rand_unit()
        Pa = projector(a)
        M = [[complex(random.gauss(0, 2), random.gauss(0, 2)) for _ in range(2)]
             for _ in range(2)]
        lhs = mat_mul(mat_mul(Pa, M), Pa)
        rhs = mat_scale(trace(mat_mul(Pa, M)), Pa)
        if not mat_close(lhs, rhs):
            print("FAIL general collapse")
            ok = False
        # antipodal completeness and orthogonality
        Pn = projector(tuple(-x for x in a))
        if not mat_close(mat_add(Pa, Pn), ID2):
            print("FAIL antipodal completeness")
            ok = False
        if not mat_close(mat_mul(Pa, Pn), [[0, 0], [0, 0]]):
            print("FAIL antipodal orthogonality")
            ok = False
        # quaternionic rank-one: lam lam^dagger is Hermitian with null
        # future-pointing momentum (d = 6, signature (+,-,-,-,-,-))
        lam = [tuple(random.gauss(0, 1) for _ in range(4)) for _ in range(2)]
        m00 = qmul(lam[0], qconj(lam[0]))
        m11 = qmul(lam[1], qconj(lam[1]))
        m01 = qmul(lam[0], qconj(lam[1]))
        m10 = qmul(lam[1], qconj(lam[0]))
        if any(abs(x - y) > 1e-9 for x, y in zip(m10, qconj(m01))):
            print("FAIL quaternion hermitian")
            ok = False
        p0 = (m00[0] + m11[0]) / 2
        p5 = (m00[0] - m11[0]) / 2
        if abs(p0 * p0 - (qnormsq(m01) + p5 * p5)) > 1e-8 or p0 < -1e-12:
            print("FAIL quaternion null/future")
            ok = False
        # quaternionic forward construction (0 < p0 + p5 chart)
        q = tuple(random.gauss(0, 2) for _ in range(4))
        p5 = random.gauss(0, 2)
        p0 = math.sqrt(qnormsq(q) + p5 * p5)
        if p0 + p5 > 1e-9:
            s = math.sqrt(p0 + p5)
            lam0 = (s, 0, 0, 0)
            lam1 = tuple(x / s for x in qconj(q))
            d00 = qmul(lam0, qconj(lam0))
            d11 = qmul(lam1, qconj(lam1))
            off = qmul(lam0, qconj(lam1))
            if abs(d00[0] - (p0 + p5)) > 1e-8 or abs(d11[0] - (p0 - p5)) > 1e-8 \
                    or any(abs(x - y) > 1e-8 for x, y in zip(off, q)):
                print("FAIL quaternion construction")
                ok = False
    print("wave-2 collapse + quaternionic rank-one:", "OK" if ok else "FAILED")
    return ok

if __name__ == "__main__":
    all_ok = True
    all_ok &= check_corner_counts()
    all_ok &= check_recursions()
    all_ok &= check_pauli()
    all_ok &= check_wave2()
    print("ALL OK" if all_ok else "SOME CHECKS FAILED")
