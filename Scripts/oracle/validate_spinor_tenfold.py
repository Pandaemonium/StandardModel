r"""Oracle validator for the Spin(10) Fock-model spinor conventions.

This script mirrors, in exact rational arithmetic, the definitions intended for
the Lean modules:

  - PhysicsSM/Spinor/SpinorTenfoldFock.lean
  - PhysicsSM/Spinor/SpinorTenfoldPurity.lean
  - PhysicsSM/Algebra/Jordan/CayleyPlaneD5Chart.lean

Model
-----
* Full spinor space: Lambda^*(C^5), basis indexed by subsets S of {0,..,4},
  represented here as frozensets.  A spinor is a dict {frozenset: Fraction}.
* Even (positive-chirality) spinors: supported on even-cardinality subsets.
* Vector space V = C^10 split hyperbolically as (a, b) with a, b in C^5.
  Quadratic form Q(a, b) = sum_i a_i b_i.
  Symmetric bilinear form B((a,b),(a',b')) = sum_i (a_i b'_i + b_i a'_i),
  so that B(v, v) = 2 Q(v).
* Clifford action: (a,b) . psi = sum_i a_i e_i /\ psi + sum_i b_i iota_{f_i} psi.
  Then v . (v . psi) = Q(v) psi  (checked below).
* Chevalley pairing: beta(psi, phi) = sum_S twist(|S|) shuffleSign(S)
  psi(S) phi(S^c), where shuffleSign(S) is the sign of the permutation
  (sorted S, sorted S^c) of (0,..,4), and twist(k) is one of the candidate
  conventions tested below (main anti-automorphism alpha gives
  twist(k) = (-1)^(k(k-1)/2)).
* Gamma bilinear q(psi, phi) in V, defined by adjunction
      B(q(psi, phi), v) = beta(v . psi, phi) for all v,
  i.e. componentwise  q_a[j] = beta(f_j . psi, phi),
                      q_b[j] = beta(e_j . psi, phi).

Tests
-----
1. Clifford relation v.(v.psi) = Q(v) psi.
2. For each twist convention: symmetry q(psi,phi) = q(phi,psi) on even spinors.
3. For each twist convention: the D=10 Fierz/SUSY identity
   q(psi,psi) . psi = 0 and Q(q(psi,psi)) = 0 for arbitrary even psi.
4. Normal-form witnesses psi1 = delta_{}, psi2 = delta_{3,4}:
   both pure, q(psi1,psi2) = 0, psi1 + psi2 pure (the d=3 Krasnov pair).
5. Annihilator subspaces N_{psi1}, N_{psi2} and dim(N1 cap N2) = 3.

Provenance: clean-room implementation from Chevalley's "The Algebraic Theory
of Spinors" conventions; used only as an oracle to pin signs for the Lean
formalization, never as a trusted proof.

Tool: CPython (exact Fraction arithmetic). Run: python validate_spinor_tenfold.py
"""

from fractions import Fraction
from itertools import combinations
import random

random.seed(20260609)

N = 5
ALL_SUBSETS = [frozenset(c) for k in range(N + 1) for c in combinations(range(N), k)]
EVEN_SUBSETS = [S for S in ALL_SUBSETS if len(S) % 2 == 0]


def zero_spinor():
    return {S: Fraction(0) for S in ALL_SUBSETS}


def rand_even_spinor():
    psi = zero_spinor()
    for S in EVEN_SUBSETS:
        psi[S] = Fraction(random.randint(-9, 9))
    return psi


def add(p, q):
    return {S: p[S] + q[S] for S in ALL_SUBSETS}


def smul(c, p):
    return {S: c * p[S] for S in ALL_SUBSETS}


def is_zero(p):
    return all(v == 0 for v in p.values())


def below_count(i, S):
    """#{j in S : j < i} -- the sign exponent for creation/annihilation."""
    return sum(1 for j in S if j < i)


def wedge(i, psi):
    """Creation operator e_i /\\ -."""
    out = zero_spinor()
    for S in ALL_SUBSETS:
        if i in S:
            # (e_i /\ psi)(S) = (-1)^{#{j in S\{i} : j < i}} psi(S \ {i})
            out[S] = Fraction((-1) ** below_count(i, S - {i})) * psi[S - {i}]
    return out


def contract(i, psi):
    """Annihilation operator iota_{f_i}."""
    out = zero_spinor()
    for S in ALL_SUBSETS:
        if i not in S:
            # (iota_i psi)(S) = (-1)^{#{j in S : j < i}} psi(S u {i})
            out[S] = Fraction((-1) ** below_count(i, S)) * psi[S | {i}]
    return out


def clifford(v, psi):
    a, b = v
    out = zero_spinor()
    for i in range(N):
        if a[i] != 0:
            out = add(out, smul(a[i], wedge(i, psi)))
        if b[i] != 0:
            out = add(out, smul(b[i], contract(i, psi)))
    return out


def Q(v):
    a, b = v
    return sum(a[i] * b[i] for i in range(N))


def Bform(v, w):
    a, b = v
    c, d = w
    return sum(a[i] * d[i] + b[i] * c[i] for i in range(N))


def shuffle_sign(S):
    """Sign of the permutation (sorted S, sorted S^c) of (0,...,4)."""
    seq = sorted(S) + sorted(set(range(N)) - S)
    sign = 1
    for x in range(len(seq)):
        for y in range(x + 1, len(seq)):
            if seq[x] > seq[y]:
                sign = -sign
    return sign


TWISTS = {
    "no_twist": lambda k: 1,
    "alpha": lambda k: (-1) ** (k * (k - 1) // 2),
}


def beta(psi, phi, twist):
    total = Fraction(0)
    for S in ALL_SUBSETS:
        Sc = frozenset(range(N)) - S
        total += Fraction(twist(len(S)) * shuffle_sign(S)) * psi[S] * phi[Sc]
    return total


def unit_vec(i, slot):
    a = [Fraction(0)] * N
    b = [Fraction(0)] * N
    if slot == "a":
        a[i] = Fraction(1)
    else:
        b[i] = Fraction(1)
    return (a, b)


def q_bilinear(psi, phi, twist):
    """q(psi, phi) in V with B(q, v) = beta(v.psi, phi)."""
    qa = [beta(clifford(unit_vec(j, "b"), psi), phi, twist) for j in range(N)]
    qb = [beta(clifford(unit_vec(j, "a"), psi), phi, twist) for j in range(N)]
    return (qa, qb)


def rand_vec():
    a = [Fraction(random.randint(-9, 9)) for _ in range(N)]
    b = [Fraction(random.randint(-9, 9)) for _ in range(N)]
    return (a, b)


def indicator(S):
    psi = zero_spinor()
    psi[frozenset(S)] = Fraction(1)
    return psi


def smul_vec(c, v):
    a, b = v
    return ([c * x for x in a], [c * x for x in b])


def sub_vec(v, w):
    a, b = v
    c, d = w
    return ([a[i] - c[i] for i in range(N)], [b[i] - d[i] for i in range(N)])


def rho(v, w, psi):
    """Infinitesimal spin action: rho(v, w) = (1/2)(gamma_v gamma_w - gamma_w gamma_v)."""
    lhs = clifford(v, clifford(w, psi))
    rhs = clifford(w, clifford(v, psi))
    return {S: Fraction(1, 2) * (lhs[S] - rhs[S]) for S in ALL_SUBSETS}


def so_ad(v, w, u):
    """so(10) action on vectors: ad(v ^ w) u = B(w,u) v - B(v,u) w."""
    return sub_vec(smul_vec(Bform(w, u), v), smul_vec(Bform(v, u), w))


def test_so10_action(failures):
    """Oracle checks for the infinitesimal Spin(10) action statements
    (PhysicsSM/Draft/SpinorTenfoldSO10ActionAristotle.lean)."""
    twist = TWISTS["alpha"]
    ok_int, ok_skew, ok_equiv, ok_bracket = True, True, True, True
    for _ in range(8):
        v, w, u, v2, w2 = (rand_vec() for _ in range(5))
        psi, phi = rand_even_spinor(), rand_even_spinor()
        # Intertwining relation [rho(v,w), gamma_u] = gamma_{ad(v^w)u}.
        lhs = rho(v, w, clifford(u, psi))
        rhs = clifford(u, rho(v, w, psi))
        diff = {S: lhs[S] - rhs[S] for S in ALL_SUBSETS}
        expect = clifford(so_ad(v, w, u), psi)
        if any(diff[S] != expect[S] for S in ALL_SUBSETS):
            ok_int = False
        # Skew-invariance of the Chevalley pairing.
        if beta(rho(v, w, psi), phi, twist) + beta(psi, rho(v, w, phi), twist) != 0:
            ok_skew = False
        # Equivariance of the gamma bilinear.
        qa1, qb1 = q_bilinear(rho(v, w, psi), phi, twist)
        qa2, qb2 = q_bilinear(psi, rho(v, w, phi), twist)
        ea, eb = so_ad(v, w, q_bilinear(psi, phi, twist))
        if any(qa1[j] + qa2[j] != ea[j] for j in range(N)) or any(
            qb1[j] + qb2[j] != eb[j] for j in range(N)
        ):
            ok_equiv = False
        # so(10) bracket relation.
        lhs2 = rho(v, w, rho(v2, w2, psi))
        rhs2 = rho(v2, w2, rho(v, w, psi))
        br = {S: lhs2[S] - rhs2[S] for S in ALL_SUBSETS}
        t1 = smul(Bform(w, v2), rho(v, w2, psi))
        t2 = smul(Bform(v, v2), rho(w, w2, psi))
        t3 = smul(Bform(w, w2), rho(v, v2, psi))
        t4 = smul(Bform(v, w2), rho(w, v2, psi))
        for S in ALL_SUBSETS:
            if br[S] != t1[S] - t2[S] - t3[S] + t4[S]:
                ok_bracket = False
                break
    print("[so10] intertwine [rho, gamma_u] = gamma_{ad u}:", "OK" if ok_int else "FAIL")
    print("[so10] Chevalley pairing skew-invariance:", "OK" if ok_skew else "FAIL")
    print("[so10] gamma-bilinear equivariance:", "OK" if ok_equiv else "FAIL")
    print("[so10] bracket relation:", "OK" if ok_bracket else "FAIL")
    for name, ok in [("so10_intertwine", ok_int), ("so10_skew", ok_skew),
                     ("so10_equivariance", ok_equiv), ("so10_bracket", ok_bracket)]:
        if not ok:
            failures.append(name)


def main():
    failures = []

    # --- Test 1: Clifford relation ---
    for _ in range(20):
        v = rand_vec()
        psi = rand_even_spinor()
        lhs = clifford(v, clifford(v, psi))
        rhs = smul(Q(v), psi)
        if not is_zero(add(lhs, smul(Fraction(-1), rhs))):
            failures.append("clifford_sq")
            break
    print("Clifford relation v.(v.psi) = Q(v) psi :", "OK" if "clifford_sq" not in failures else "FAIL")

    # --- Test: adjunction definition consistency B(q, v) = beta(v.psi, phi) ---
    for name, twist in TWISTS.items():
        ok = True
        for _ in range(10):
            psi, phi, v = rand_even_spinor(), rand_even_spinor(), rand_vec()
            qv = q_bilinear(psi, phi, twist)
            if Bform(qv, v) != beta(clifford(v, psi), phi, twist):
                ok = False
                break
        print(f"[{name}] adjunction B(q,v) = beta(v.psi, phi):", "OK" if ok else "FAIL")
        if not ok:
            failures.append(f"adjunction:{name}")

    # --- Tests 2-3: symmetry and Fierz, per twist convention ---
    for name, twist in TWISTS.items():
        sym_ok = True
        fierz_ok = True
        for _ in range(15):
            psi = rand_even_spinor()
            phi = rand_even_spinor()
            q1 = q_bilinear(psi, phi, twist)
            q2 = q_bilinear(phi, psi, twist)
            if q1 != q2:
                sym_ok = False
            qpsi = q_bilinear(psi, psi, twist)
            if not is_zero(clifford(qpsi, psi)):
                fierz_ok = False
            if Q(qpsi) != 0:
                fierz_ok = False
        print(f"[{name}] q symmetric on even spinors:", "OK" if sym_ok else "FAIL")
        print(f"[{name}] Fierz q(psi).psi = 0 and Q(q(psi)) = 0:", "OK" if fierz_ok else "FAIL")
        if not sym_ok:
            failures.append(f"symmetry:{name}")
        if not fierz_ok:
            failures.append(f"fierz:{name}")

    # --- Test 4: normal-form witnesses (use alpha twist by default; report both) ---
    for name, twist in TWISTS.items():
        psi1 = indicator(())
        psi2 = indicator((3, 4))
        q11 = q_bilinear(psi1, psi1, twist)
        q22 = q_bilinear(psi2, psi2, twist)
        q12 = q_bilinear(psi1, psi2, twist)
        s = add(psi1, psi2)
        qss = q_bilinear(s, s, twist)
        w_ok = (
            all(x == 0 for x in q11[0] + q11[1])
            and all(x == 0 for x in q22[0] + q22[1])
            and all(x == 0 for x in q12[0] + q12[1])
            and all(x == 0 for x in qss[0] + qss[1])
        )
        print(f"[{name}] witnesses psi1=vac, psi2=e3^e4 pure, orthogonal, sum pure:", "OK" if w_ok else "FAIL")
        if not w_ok:
            failures.append(f"witnesses:{name}")

    # --- Test 5: annihilator dimensions ---
    # N_psi = {v : v.psi = 0}. For psi1 = vacuum: v.psi1 = sum a_i e_i, so
    # N_1 = {(0, b)} (the f-span). For psi2 = delta_{3,4}: creation by i in {3,4}
    # kills it, contraction by i in {0,1,2} kills it, so
    # N_2 = span(e_3, e_4, f_0, f_1, f_2). N_1 cap N_2 = span(f_0, f_1, f_2), dim 3.
    psi1 = indicator(())
    psi2 = indicator((3, 4))

    def in_annihilator(v, psi):
        return is_zero(clifford(v, psi))

    n1_basis = [unit_vec(i, "b") for i in range(N)]
    n2_basis = [unit_vec(3, "a"), unit_vec(4, "a")] + [unit_vec(i, "b") for i in range(3)]
    ann_ok = all(in_annihilator(v, psi1) for v in n1_basis) and all(
        in_annihilator(v, psi2) for v in n2_basis
    )
    # Check that nothing outside these spans annihilates (spot check on basis vectors).
    extra = [unit_vec(i, "a") for i in range(N)]
    ann_ok = ann_ok and not any(in_annihilator(v, psi1) for v in extra)
    ann_ok = ann_ok and not any(
        in_annihilator(unit_vec(i, s), psi2)
        for (i, s) in [(0, "a"), (1, "a"), (2, "a"), (3, "b"), (4, "b")]
    )
    print("Annihilators N1 = <f_i>, N2 = <e_3,e_4,f_0,f_1,f_2>, N1 cap N2 = C^3:", "OK" if ann_ok else "FAIL")
    if not ann_ok:
        failures.append("annihilators")

    # --- Test 6: infinitesimal Spin(10) action ---
    test_so10_action(failures)

    print()
    # The no-twist convention is *expected* to fail symmetry and Fierz; it is
    # tested only to demonstrate that the alpha twist is load-bearing. Only
    # failures of the alpha convention (the one used in Lean) are fatal.
    expected = {"symmetry:no_twist", "fierz:no_twist"}
    fatal = [f for f in failures if f not in expected]
    if fatal:
        print("FATAL FAILURES:", fatal)
        raise SystemExit(1)
    print("All checks for the alpha-twist convention passed.")
    print("(no_twist symmetry/Fierz failures above are expected and demonstrate")
    print(" that the alpha twist is required.)")


if __name__ == "__main__":
    main()
