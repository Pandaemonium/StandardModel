r"""Oracle for the bioctonion <-> Fock spinor bridge (Baez-Huerta final stage).

This script constructs, in exact Gaussian-rational arithmetic, an explicit
intertwiner between the two D = 10 spinor models of the repository:

  * the bioctonionic model of PhysicsSM/Algebra/Octonion/SpinorFierz.lean:
    spinors are pairs of complexified octonions (COctSpinor), vectors are
    complexified 2x2 hermitian octonionic matrices (CHermVector), the
    Clifford action is hermActionC with trace reversal hermTraceRevC, and
    the quadratic form is N(A) = normSqC(A.y) - A.a * A.b;

  * the Fock model of PhysicsSM/Spinor/SpinorTenfoldFock.lean:
    spinors are functions Finset(Fin 5) -> C, vectors are hyperbolic pairs
    V10 = C^5 x C^5 with Q10(a,b) = sum_i a_i b_i, the Clifford action is
    wedge/contract with the belowCount sign convention.

Construction
------------
1. The vector bridge iota : V10 -> CHermVector sends the hyperbolic basis to
   null bioctonionic vectors:
     iota(e_4) = (a=1, b=0, y=0),       iota(f_4) = (a=0, b=-1, y=0),
     iota(e_j) = (0, 0, n_j),           iota(f_j) = (0, 0, m_j),   j = 0..3,
   with n_j = (e_{p_j} - i e_{q_j})/2, m_j = (e_{p_j} + i e_{q_j})/2 for the
   unit pairing (p_j, q_j) = (j, 7-j) (octonion labels in the project XOR
   convention, q_j = p_j XOR 111).  This matches the bilinear forms:
   B_oct(iota u, iota v) = B10(u, v) where B_oct is the polarization of N.
2. The octonionic vacuum chi(empty) is the (1-dimensional) common kernel of
   the five annihilation operators hermActionC(iota f_j).
3. chi(S) for general S is built by applying creation operators
   "largest index first" so all Fock-side signs are +1, alternating the
   chirality convention: from the even (S+) side apply hermActionC(A), from
   the odd (S-) side apply hermActionC(hermTraceRevC A).  The script checks
   that the same recursion on the Fock side reproduces basisSpinor S on the
   nose (sign +1).
4. The bridge fockToOct(psi) = sum_S psi(S) chi(S) then intertwines:
     even psi: hermActionC(iota v)        (F psi) = F(cliffordAction v psi)
     odd  psi: hermActionC(~(iota v))     (F psi) = F(cliffordAction v psi)
   (checked for all 10 basis vectors against all 32 basis spinors).
5. The restriction of F to even (resp. odd) spinors is a linear isomorphism
   onto the bioctonionic spinor space; the inverse matrix is computed and
   printed.
6. The quadric bridge: on even spinors,
     spinorSquareC(F psi) = c * iota(gammaBilinear(psi, psi))
   for a single constant c, computed and verified on random spinors.
   (gammaBilinear uses the alpha-twisted Chevalley pairing, as in
   validate_spinor_tenfold.py.)

Everything is printed in Lean-ready exact form at the end.

Provenance: clean-room construction following Baez-Huerta, "Division
algebras and supersymmetry I" (arXiv:0909.0551) and Chevalley's Fock
construction; used only as an oracle to pin definitions and signs for the
Lean formalization, never as a trusted proof.

Tool: CPython, exact Fraction arithmetic.
Run: python validate_bioctonion_fock_bridge.py
"""

from fractions import Fraction
from itertools import combinations
import random

random.seed(20260610)

# ----------------------------------------------------------------------
# Gaussian rationals
# ----------------------------------------------------------------------

class QI:
    """Gaussian rational a + b i with exact Fraction parts."""
    __slots__ = ("re", "im")

    def __init__(self, re=0, im=0):
        self.re = Fraction(re)
        self.im = Fraction(im)

    def __add__(self, o):
        return QI(self.re + o.re, self.im + o.im)

    def __sub__(self, o):
        return QI(self.re - o.re, self.im - o.im)

    def __neg__(self):
        return QI(-self.re, -self.im)

    def __mul__(self, o):
        return QI(self.re * o.re - self.im * o.im,
                  self.re * o.im + self.im * o.re)

    def inv(self):
        n = self.re * self.re + self.im * self.im
        return QI(self.re / n, -self.im / n)

    def __eq__(self, o):
        return self.re == o.re and self.im == o.im

    def is_zero(self):
        return self.re == 0 and self.im == 0

    def __repr__(self):
        return f"({self.re}+{self.im}i)"


ZERO = QI()
ONE = QI(1)
I = QI(0, 1)
HALF = QI(Fraction(1, 2))


# ----------------------------------------------------------------------
# Project XOR octonions, complexified
# ----------------------------------------------------------------------

TRIPLES = [
    (0b001, 0b010, 0b011),
    (0b001, 0b101, 0b100),
    (0b001, 0b110, 0b111),
    (0b010, 0b100, 0b110),
    (0b010, 0b101, 0b111),
    (0b011, 0b101, 0b110),
    (0b011, 0b111, 0b100),
]


def build_table():
    table = {}
    for i in range(8):
        table[(0, i)] = (1, i)
        table[(i, 0)] = (1, i)
    for i in range(1, 8):
        table[(i, i)] = (-1, 0)
    for a, b_, c in TRIPLES:
        for x, y, z in [(a, b_, c), (b_, c, a), (c, a, b_)]:
            table[(x, y)] = (1, z)
            table[(y, x)] = (-1, z)
    assert len(table) == 64
    return table


MUL_TABLE = build_table()


def oct_zero():
    return [QI() for _ in range(8)]


def oct_unit(k):
    v = oct_zero()
    v[k] = QI(1)
    return v


def oct_add(x, y):
    return [a + b for a, b in zip(x, y)]


def oct_sub(x, y):
    return [a - b for a, b in zip(x, y)]


def oct_smul(c, x):
    return [c * a for a in x]


def oct_mul(x, y):
    out = oct_zero()
    for a in range(8):
        if x[a].is_zero():
            continue
        for b in range(8):
            if y[b].is_zero():
                continue
            s, c = MUL_TABLE[(a, b)]
            term = x[a] * y[b]
            if s < 0:
                term = -term
            out[c] = out[c] + term
    return out


def oct_conj(x):
    """Octonionic conjugation: negate units 1..7 (this is octConjC)."""
    return [x[0]] + [-a for a in x[1:]]


def oct_dot(x, y):
    """C-bilinear dot product (dotOct extended bilinearly)."""
    s = QI()
    for a, b in zip(x, y):
        s = s + a * b
    return s


def oct_is_zero(x):
    return all(a.is_zero() for a in x)


def norm_sq_c(x):
    """C-bilinear extension of normSq: sum of squares of coordinates."""
    return oct_dot(x, x)


# ----------------------------------------------------------------------
# Bioctonionic spinor model (mirrors SpinorFierz.lean complexified defs)
# ----------------------------------------------------------------------

# COctSpinor: pair (fst, snd) of bioctonions.
# CHermVector: (a, b, y) with a, b in QI, y a bioctonion.

def herm_trace_rev(A):
    a, b, y = A
    return (-b, -a, y)


def herm_action(A, psi):
    a, b, y = A
    p1, p2 = psi
    out1 = oct_add(oct_smul(a, p1), oct_mul(y, p2))
    out2 = oct_add(oct_mul(oct_conj(y), p1), oct_smul(b, p2))
    return (out1, out2)


def spinor_square_c(psi):
    p1, p2 = psi
    return (norm_sq_c(p1), norm_sq_c(p2), oct_mul(p1, oct_conj(p2)))


def cspinor_add(x, y):
    return (oct_add(x[0], y[0]), oct_add(x[1], y[1]))


def cspinor_smul(c, x):
    return (oct_smul(c, x[0]), oct_smul(c, x[1]))


def cspinor_zero():
    return (oct_zero(), oct_zero())


def cspinor_is_zero(x):
    return oct_is_zero(x[0]) and oct_is_zero(x[1])


def cspinor_coords(x):
    return list(x[0]) + list(x[1])


def coords_to_cspinor(v):
    return (list(v[:8]), list(v[8:]))


# ----------------------------------------------------------------------
# Fock model (mirrors SpinorTenfoldFock.lean; QI coefficients)
# ----------------------------------------------------------------------

N = 5
ALL_SUBSETS = [frozenset(c) for k in range(N + 1)
               for c in combinations(range(N), k)]
SUBSET_INDEX = {S: i for i, S in enumerate(ALL_SUBSETS)}
EVEN_SUBSETS = [S for S in ALL_SUBSETS if len(S) % 2 == 0]
ODD_SUBSETS = [S for S in ALL_SUBSETS if len(S) % 2 == 1]


def fock_zero():
    return {S: QI() for S in ALL_SUBSETS}


def fock_delta(S):
    psi = fock_zero()
    psi[S] = QI(1)
    return psi


def fock_add(p, q):
    return {S: p[S] + q[S] for S in ALL_SUBSETS}


def fock_smul(c, p):
    return {S: c * p[S] for S in ALL_SUBSETS}


def fock_is_zero(p):
    return all(v.is_zero() for v in p.values())


def below_count(i, S):
    return sum(1 for j in S if j < i)


def op_sign(i, S):
    return QI((-1) ** below_count(i, S))


def wedge(i, psi):
    out = fock_zero()
    for S in ALL_SUBSETS:
        if i in S:
            out[S] = op_sign(i, S) * psi[S - {i}]
    return out


def contract(i, psi):
    out = fock_zero()
    for S in ALL_SUBSETS:
        if i not in S:
            out[S] = op_sign(i, S) * psi[S | {i}]
    return out


def clifford(v, psi):
    """v = (avec, bvec): lists of 5 QI each."""
    avec, bvec = v
    out = fock_zero()
    for i in range(N):
        if not avec[i].is_zero():
            out = fock_add(out, fock_smul(avec[i], wedge(i, psi)))
        if not bvec[i].is_zero():
            out = fock_add(out, fock_smul(bvec[i], contract(i, psi)))
    return out


def v10_e(j):
    a = [QI() for _ in range(5)]
    a[j] = QI(1)
    return (a, [QI() for _ in range(5)])


def v10_f(j):
    b = [QI() for _ in range(5)]
    b[j] = QI(1)
    return ([QI() for _ in range(5)], b)


V10_BASIS = [("e", j, v10_e(j)) for j in range(5)] \
    + [("f", j, v10_f(j)) for j in range(5)]


def b10(u, v):
    s = QI()
    for i in range(5):
        s = s + u[0][i] * v[1][i] + u[1][i] * v[0][i]
    return s


# Chevalley pairing with the alpha twist (the project convention).

def shuffle_sign(S):
    perm = sorted(S) + sorted(set(range(N)) - S)
    sign = 1
    for i in range(len(perm)):
        for j in range(i + 1, len(perm)):
            if perm[i] > perm[j]:
                sign = -sign
    return sign


def chev_sign(S):
    k = len(S)
    alpha = (-1) ** (k * (k - 1) // 2)
    return QI(alpha * shuffle_sign(S))


def chevalley(psi, phi):
    s = QI()
    for S in ALL_SUBSETS:
        comp = frozenset(range(N)) - S
        s = s + chev_sign(S) * psi[S] * phi[comp]
    return s


def gamma_bilinear(psi, phi):
    qa = [chevalley(contract(j, psi), phi) for j in range(5)]
    qb = [chevalley(wedge(j, psi), phi) for j in range(5)]
    return (qa, qb)


# ----------------------------------------------------------------------
# The vector bridge iota
# ----------------------------------------------------------------------

UNIT_PAIRING = [(0, 7), (1, 6), (2, 5), (3, 4)]  # (p_j, q_j), q = p XOR 0b111


def herm_zero_y():
    return oct_zero()


def iota_e(j):
    if j == 4:
        return (QI(), QI(-1), herm_zero_y())
    p, q = UNIT_PAIRING[j]
    y = oct_sub(oct_unit(p), oct_smul(I, oct_unit(q)))
    return (QI(), QI(), oct_smul(HALF, y))


def iota_f(j):
    if j == 4:
        return (QI(1), QI(), herm_zero_y())
    p, q = UNIT_PAIRING[j]
    y = oct_add(oct_unit(p), oct_smul(I, oct_unit(q)))
    return (QI(), QI(), oct_smul(HALF, y))


def iota(v):
    """Linear extension of the basis assignment."""
    avec, bvec = v
    a_tot, b_tot, y_tot = QI(), QI(), oct_zero()
    for j in range(5):
        for coeff, base in ((avec[j], iota_e(j)), (bvec[j], iota_f(j))):
            if coeff.is_zero():
                continue
            a_tot = a_tot + coeff * base[0]
            b_tot = b_tot + coeff * base[1]
            y_tot = oct_add(y_tot, oct_smul(coeff, base[2]))
    return (a_tot, b_tot, y_tot)


def b_oct(A, B):
    """Polarization of N(A) = normSqC(y) - a b."""
    aA, bA, yA = A
    aB, bB, yB = B
    two = QI(2)
    return two * oct_dot(yA, yB) - aA * bB - aB * bA


# ----------------------------------------------------------------------
# Linear algebra over QI
# ----------------------------------------------------------------------

def kernel_basis(rows):
    """Kernel of the matrix with the given rows (lists of QI), by Gaussian
    elimination.  Returns a list of basis vectors."""
    if not rows:
        return []
    ncols = len(rows[0])
    mat = [list(r) for r in rows]
    pivots = []
    r = 0
    for c in range(ncols):
        piv = None
        for rr in range(r, len(mat)):
            if not mat[rr][c].is_zero():
                piv = rr
                break
        if piv is None:
            continue
        mat[r], mat[piv] = mat[piv], mat[r]
        inv = mat[r][c].inv()
        mat[r] = [inv * x for x in mat[r]]
        for rr in range(len(mat)):
            if rr != r and not mat[rr][c].is_zero():
                f = mat[rr][c]
                mat[rr] = [x - f * y for x, y in zip(mat[rr], mat[r])]
        pivots.append(c)
        r += 1
        if r == len(mat):
            break
    free = [c for c in range(ncols) if c not in pivots]
    basis = []
    for fc in free:
        vec = [QI() for _ in range(ncols)]
        vec[fc] = QI(1)
        for ri, pc in enumerate(pivots):
            vec[pc] = -mat[ri][fc]
        basis.append(vec)
    return basis


def invert_matrix(cols):
    """Invert the square matrix whose COLUMNS are the given vectors."""
    n = len(cols)
    mat = [[cols[j][i] for j in range(n)] + [QI(1) if k == i else QI()
                                             for k in range(n)]
           for i in range(n)]
    for c in range(n):
        piv = None
        for rr in range(c, n):
            if not mat[rr][c].is_zero():
                piv = rr
                break
        assert piv is not None, "matrix not invertible"
        mat[c], mat[piv] = mat[piv], mat[c]
        inv = mat[c][c].inv()
        mat[c] = [inv * x for x in mat[c]]
        for rr in range(n):
            if rr != c and not mat[rr][c].is_zero():
                f = mat[rr][c]
                mat[rr] = [x - f * y for x, y in zip(mat[rr], mat[c])]
    return [[mat[i][n + j] for j in range(n)] for i in range(n)]


# ----------------------------------------------------------------------
# Step 0: form match  B_oct(iota u, iota v) = B10(u, v)
# ----------------------------------------------------------------------

def test_form_match():
    ok = True
    for n1, j1, u in V10_BASIS:
        for n2, j2, v in V10_BASIS:
            lhs = b_oct(iota(u), iota(v))
            rhs = b10(u, v)
            if lhs != rhs:
                ok = False
                print(f"  FORM MISMATCH {n1}{j1},{n2}{j2}: {lhs} vs {rhs}")
    print(f"[bridge] iota matches bilinear forms: {'OK' if ok else 'FAIL'}")
    return ok


# ----------------------------------------------------------------------
# Step 1: the octonionic vacuum
# ----------------------------------------------------------------------

def gamma_oct_matrix(A):
    """16x16 matrix (list of rows) of psi |-> herm_action(A, psi) in the
    coordinate basis of COctSpinor."""
    rows = [[QI() for _ in range(16)] for _ in range(16)]
    for k in range(16):
        basis_vec = [QI() for _ in range(16)]
        basis_vec[k] = QI(1)
        img = herm_action(A, coords_to_cspinor(basis_vec))
        for r, val in enumerate(cspinor_coords(img)):
            rows[r][k] = val
    return rows


def find_vacuum():
    rows = []
    for j in range(5):
        rows.extend(gamma_oct_matrix(iota_f(j)))
    basis = kernel_basis(rows)
    print(f"[bridge] common kernel of the five annihilators: dim {len(basis)}"
          f" {'OK' if len(basis) == 1 else 'FAIL'}")
    assert len(basis) == 1
    vac = coords_to_cspinor(basis[0])
    # Normalize: make the first nonzero coordinate 1 (already reduced), then
    # clear denominators to taste.  Keep as-is; print for inspection.
    return vac


# ----------------------------------------------------------------------
# Step 2: chi(S) by the creation recursion (largest index first)
# ----------------------------------------------------------------------

def fock_chi(S):
    """Fock-side mirror of the recursion; must equal fock_delta(S)."""
    if not S:
        return fock_delta(frozenset())
    i = min(S)
    return wedge(i, fock_chi(S - {i}))


def build_chi(vacuum):
    chi = {frozenset(): vacuum}

    def rec(S):
        if S in chi:
            return chi[S]
        i = min(S)
        rest = S - {i}
        sub = rec(rest)
        A = iota_e(i)
        if len(rest) % 2 == 0:
            img = herm_action(A, sub)
        else:
            img = herm_action(herm_trace_rev(A), sub)
        chi[S] = img
        return img

    for S in ALL_SUBSETS:
        rec(S)
    return chi


def test_fock_recursion():
    ok = True
    for S in ALL_SUBSETS:
        got = fock_chi(S)
        want = fock_delta(S)
        if any(got[T] != want[T] for T in ALL_SUBSETS):
            ok = False
            print(f"  FOCK RECURSION FAILS at {sorted(S)}")
    print(f"[bridge] Fock recursion gives basis spinors with sign +1: "
          f"{'OK' if ok else 'FAIL'}")
    return ok


# ----------------------------------------------------------------------
# Step 3: intertwining test
# ----------------------------------------------------------------------

def fock_to_oct(chi, psi):
    out = cspinor_zero()
    for S in ALL_SUBSETS:
        if not psi[S].is_zero():
            out = cspinor_add(out, cspinor_smul(psi[S], chi[S]))
    return out


def test_intertwining(chi):
    ok = True
    for name, j, u in V10_BASIS:
        A = iota(u)
        At = herm_trace_rev(A)
        for S in ALL_SUBSETS:
            lhs_oct = herm_action(A if len(S) % 2 == 0 else At, chi[S])
            rhs = fock_to_oct(chi, clifford(u, fock_delta(S)))
            if cspinor_coords(lhs_oct) != cspinor_coords(rhs):
                ok = False
                print(f"  INTERTWINING FAILS: {name}{j} on {sorted(S)}")
    print(f"[bridge] intertwining (all 10 vectors x 32 basis spinors): "
          f"{'OK' if ok else 'FAIL'}")
    return ok


# ----------------------------------------------------------------------
# Step 4: invertibility on each chirality
# ----------------------------------------------------------------------

def test_invertibility(chi):
    results = {}
    for name, subsets in (("even", EVEN_SUBSETS), ("odd", ODD_SUBSETS)):
        cols = [cspinor_coords(chi[S]) for S in subsets]
        try:
            inv = invert_matrix(cols)
            results[name] = inv
            print(f"[bridge] {name} bridge invertible: OK")
        except AssertionError:
            results[name] = None
            print(f"[bridge] {name} bridge invertible: FAIL")
    return results


# ----------------------------------------------------------------------
# Step 5: the quadric bridge constant
# ----------------------------------------------------------------------

def rand_even_fock():
    psi = fock_zero()
    for S in EVEN_SUBSETS:
        psi[S] = QI(random.randint(-9, 9), random.randint(-9, 9))
    return psi


def herm_coords(A):
    a, b, y = A
    return [a, b] + list(y)


def test_quadric_bridge(chi, trials=6):
    """Find c with spinorSquareC(F psi) = c * hermTraceRev(iota(q(psi, psi))).

    The trace reversal appears because the bridge realizes the Fock model on
    the chirality copy where the vacuum is annihilated by hermActionC of the
    iota(f_j) directly; the vector-valued bilinear of that copy is the
    trace-reversed one."""
    c = None
    ok = True
    for _ in range(trials):
        psi = rand_even_fock()
        s = spinor_square_c(fock_to_oct(chi, psi))
        qa, qb = gamma_bilinear(psi, psi)
        target = herm_trace_rev(iota((qa, qb)))
        sc, tc = herm_coords(s), herm_coords(target)
        for x, y in zip(sc, tc):
            if y.is_zero():
                if not x.is_zero():
                    ok = False
            else:
                ratio = x * y.inv()
                if c is None:
                    c = ratio
                elif ratio != c:
                    ok = False
    print(f"[bridge] quadric bridge spinorSquareC(F psi) = "
          f"c traceRev(iota(q(psi,psi))): {'OK' if ok else 'FAIL'}, c = {c}")
    return ok, c


# ----------------------------------------------------------------------
# Lean emission
# ----------------------------------------------------------------------

def frac_str(fr):
    if fr.denominator == 1:
        return f"{fr.numerator}"
    return f"{fr.numerator}/{fr.denominator}"


def oct_lean(x):
    """Print a bioctonion as (re-part octonion, im-part octonion)."""
    re = ", ".join(frac_str(a.re) for a in x)
    im = ", ".join(frac_str(a.im) for a in x)
    return f"re=[{re}] im=[{im}]"


def emit(chi, c, inverses):
    print()
    print("=" * 70)
    print("Lean-ready data")
    print("=" * 70)
    print("-- chi(S) images (octImage S), order: fst then snd bioctonion")
    for S in ALL_SUBSETS:
        p1, p2 = chi[S]
        print(f"S = {sorted(S)}:")
        print(f"  fst: {oct_lean(p1)}")
        print(f"  snd: {oct_lean(p2)}")
    print()
    print(f"-- quadric constant c = {c}")
    for name, subsets in (("even", EVEN_SUBSETS), ("odd", ODD_SUBSETS)):
        inv = inverses[name]
        if inv is None:
            continue
        nonzero = sum(1 for row in inv for x in row if not x.is_zero())
        denoms = sorted({x.re.denominator for row in inv for x in row}
                        | {x.im.denominator for row in inv for x in row})
        print(f"-- {name} inverse: {nonzero} nonzero entries, "
              f"denominators {denoms}")
        print(f"--   row order = subsets {[sorted(S) for S in subsets]}")
        for i, S in enumerate(subsets):
            entries = [f"{j}:{inv[i][j]}" for j in range(16)
                       if not inv[i][j].is_zero()]
            print(f"   {sorted(S)}: " + "; ".join(entries))


def main():
    print("Bioctonion <-> Fock bridge oracle")
    print("-" * 50)
    ok = test_form_match()
    ok &= test_fock_recursion()
    vac = find_vacuum()
    print("[bridge] vacuum:")
    print(f"  fst: {oct_lean(vac[0])}")
    print(f"  snd: {oct_lean(vac[1])}")
    sq = spinor_square_c(vac)
    pure = sq[0].is_zero() and sq[1].is_zero() and oct_is_zero(sq[2])
    print(f"[bridge] vacuum is bioctonionically pure (spinorSquareC = 0): "
          f"{'OK' if pure else 'FAIL'}")
    ok &= pure
    chi = build_chi(vac)
    ok &= test_intertwining(chi)
    inverses = test_invertibility(chi)
    ok &= inverses["even"] is not None and inverses["odd"] is not None
    qok, c = test_quadric_bridge(chi)
    ok &= qok
    print("-" * 50)
    print("ALL OK" if ok else "FAILURES PRESENT")
    if ok:
        emit(chi, c, inverses)
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
