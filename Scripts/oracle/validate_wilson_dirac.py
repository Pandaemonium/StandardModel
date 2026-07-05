#!/usr/bin/env python3
"""Wilson-Dirac gamma5-hermiticity + paired-flavor positivity oracle (QMF4).

Purpose: pin the EUCLIDEAN gamma-matrix and Wilson-Dirac convention for the
QMF4 statement freeze (QCD mass-formalism ladder, `RUN_PLAN.md`), and verify
numerically the two STRUCTURAL facts the QMF4 Lean statement will assert on a
finite periodic lattice at fixed coupling / fixed volume:

  (G5H)  gamma5-hermiticity:   gamma5 . D . gamma5  =  D^dagger
  (POS)  paired-flavor positivity:  det(D^dagger D) > 0  (real, strictly
         positive), i.e. the two-degenerate-flavor Wilson determinant
         det(D)^2 = det(D^dagger D) (using det D real via G5H) is positive.

CONVENTION PINNED (to be mirrored in the QMF4 Lean statement; note the repo's
`PhysicsSM/Clifford/GammaMatrices.lean` is a MINKOWSKI mostly-minus stub -
lattice field theory is EUCLIDEAN, so QMF4 needs this separate convention and
must say so):

  * Euclidean Dirac algebra: {gamma_mu, gamma_nu} = 2 delta_{mu nu} I,
    mu = 1..4, every gamma_mu HERMITIAN (gamma_mu^dagger = gamma_mu).
  * chirality: gamma5 = gamma1 gamma2 gamma3 gamma4, Hermitian, gamma5^2 = I,
    {gamma5, gamma_mu} = 0.
  * Wilson-Dirac operator on an L^4 periodic lattice, spacing a = 1, Wilson
    parameter r = 1, bare mass m, with link matrices U_mu(x) in the gauge
    group (U(1) or SU(2) here):
        D(x,y) = (m + 4 r) delta_{x,y}
                 - (1/2) sum_mu [ (r - gamma_mu) U_mu(x)      delta_{y, x+mu}
                               + (r + gamma_mu) U_mu(x-mu)^d  delta_{y, x-mu} ]
    acting on spin (x) color indices. This is the standard Wilson action; the
    (r -/+ gamma_mu) projectors are what remove the doublers at the DETERMINANT
    level (the doubling audit QMF4 records: the 15 doublers get mass ~ 2r/a and
    decouple; the one-flavor sign issue is NOT hidden - det D can be negative
    for a single flavor, which is why POS is stated for the PAIRED-flavor
    det(D^dagger D)).

Exact structural checks use tight numerical tolerances (double precision);
det(D^dagger D) positivity is checked via its sign and a Hermitian-eigenvalue
floor. Self-contained: numpy only. Exit 0 iff all checks pass.
"""

from __future__ import annotations

import itertools
import sys

import numpy as np

TOL = 1e-9


def euclidean_gammas() -> list[np.ndarray]:
    """Four 4x4 Hermitian Euclidean gamma matrices with {g_mu,g_nu}=2 delta.
    Chiral (Weyl) Euclidean basis: gamma_mu = [[0, e_mu], [e_mu^dagger, 0]]
    with e_k = -i sigma_k (k=1,2,3), e_4 = I_2."""
    I2 = np.eye(2, dtype=complex)
    sx = np.array([[0, 1], [1, 0]], dtype=complex)
    sy = np.array([[0, -1j], [1j, 0]], dtype=complex)
    sz = np.array([[1, 0], [0, -1]], dtype=complex)
    e = [-1j * sx, -1j * sy, -1j * sz, I2]  # e_1..e_4
    gammas = []
    for k in range(4):
        g = np.zeros((4, 4), dtype=complex)
        g[0:2, 2:4] = e[k]
        g[2:4, 0:2] = e[k].conj().T
        gammas.append(g)
    return gammas


def check_clifford(gammas: list[np.ndarray]) -> bool:
    ok = True
    I4 = np.eye(4, dtype=complex)
    for mu in range(4):
        # hermiticity
        if not np.allclose(gammas[mu], gammas[mu].conj().T, atol=TOL):
            print(f"  FAIL gamma_{mu+1} not Hermitian")
            ok = False
        for nu in range(4):
            anti = gammas[mu] @ gammas[nu] + gammas[nu] @ gammas[mu]
            expect = 2.0 * (1.0 if mu == nu else 0.0) * I4
            if not np.allclose(anti, expect, atol=TOL):
                print(f"  FAIL anticommutator {mu+1},{nu+1}")
                ok = False
    return ok


def gamma5(gammas: list[np.ndarray]) -> np.ndarray:
    return gammas[0] @ gammas[1] @ gammas[2] @ gammas[3]


def check_gamma5(gammas: list[np.ndarray]) -> bool:
    g5 = gamma5(gammas)
    I4 = np.eye(4, dtype=complex)
    ok = True
    if not np.allclose(g5, g5.conj().T, atol=TOL):
        print("  FAIL gamma5 not Hermitian")
        ok = False
    if not np.allclose(g5 @ g5, I4, atol=TOL):
        print("  FAIL gamma5^2 != I")
        ok = False
    for mu in range(4):
        if not np.allclose(g5 @ gammas[mu] + gammas[mu] @ g5,
                           np.zeros((4, 4)), atol=TOL):
            print(f"  FAIL gamma5 anticommute gamma_{mu+1}")
            ok = False
    return ok


def sites(L: int):
    return list(itertools.product(range(L), repeat=4))


def wilson_dirac(L: int, m: float, gammas: list[np.ndarray],
                 links, nc: int, r: float = 1.0) -> np.ndarray:
    """Assemble the Wilson-Dirac matrix. `links[mu][x]` is an nc x nc gauge
    matrix on the link from x in direction mu. Index layout: (site, spin,
    color) flattened, dim = L^4 * 4 * nc."""
    S = sites(L)
    idx = {x: n for n, x in enumerate(S)}
    V = len(S)
    dim = V * 4 * nc
    Ic = np.eye(nc, dtype=complex)
    D = np.zeros((dim, dim), dtype=complex)

    def block(nx, ny):
        rx, ry = nx * 4 * nc, ny * 4 * nc
        return (slice(rx, rx + 4 * nc), slice(ry, ry + 4 * nc))

    diag = (m + 4.0 * r) * np.kron(np.eye(4), Ic)
    for x in S:
        nx = idx[x]
        bx = block(nx, nx)
        D[bx] += diag
    for x in S:
        nx = idx[x]
        for mu in range(4):
            xp = list(x); xp[mu] = (x[mu] + 1) % L; xp = tuple(xp)
            xm = list(x); xm[mu] = (x[mu] - 1) % L; xm = tuple(xm)
            proj_fwd = np.kron(r * np.eye(4) - gammas[mu], Ic)  # (r - g_mu)
            proj_bwd = np.kron(r * np.eye(4) + gammas[mu], Ic)  # (r + g_mu)
            Umu_x = np.kron(np.eye(4), links[mu][x])
            Umu_xm = np.kron(np.eye(4), links[mu][xm].conj().T)
            D[block(nx, idx[xp])] += -0.5 * (proj_fwd @ Umu_x)
            D[block(nx, idx[xm])] += -0.5 * (proj_bwd @ Umu_xm)
    return D


def rand_u1_links(L: int, rng) -> list:
    S = sites(L)
    return [{x: np.array([[np.exp(1j * rng.uniform(0, 2 * np.pi))]],
                         dtype=complex) for x in S} for _ in range(4)]


def rand_su2_links(L: int, rng) -> list:
    S = sites(L)
    out = []
    for _ in range(4):
        d = {}
        for x in S:
            a = rng.normal(size=4)
            a /= np.linalg.norm(a)
            # SU(2) as a0 I + i(a.sigma)
            sx = np.array([[0, 1], [1, 0]], dtype=complex)
            sy = np.array([[0, -1j], [1j, 0]], dtype=complex)
            sz = np.array([[1, 0], [0, -1]], dtype=complex)
            U = a[0] * np.eye(2) + 1j * (a[1] * sx + a[2] * sy + a[3] * sz)
            d[x] = U
        out.append(d)
    return out


def main() -> int:
    rng = np.random.default_rng(20260704)
    gammas = euclidean_gammas()
    fails = 0
    checks = 0

    print("=" * 74)
    print("Wilson-Dirac gamma5-hermiticity + paired-flavor positivity (QMF4)")
    print("  Euclidean gammas Hermitian, {g_mu,g_nu}=2delta; g5=g1g2g3g4")
    print("  D Wilson-Dirac (r=1); checks: g5 D g5 = D^dagger; det(D^d D)>0")
    print("=" * 74)

    print("\n[gamma] Euclidean Clifford algebra + gamma5:")
    c1 = check_clifford(gammas)
    c2 = check_gamma5(gammas)
    checks += 2
    fails += (0 if c1 else 1) + (0 if c2 else 1)
    print(f"  clifford {'PASS' if c1 else 'FAIL'}; gamma5 {'PASS' if c2 else 'FAIL'}")

    g5 = gamma5(gammas)

    for name, mk_links, nc in [
        ("U(1)", rand_u1_links, 1),
        ("SU(2)", rand_su2_links, 2),
    ]:
        L = 2
        for m in (0.3, -0.2, 1.0):
            links = mk_links(L, rng)
            D = wilson_dirac(L, m, gammas, links, nc)
            V = L ** 4
            # gamma5-hermiticity: (I_site (x) g5 (x) I_color) D (same) = D^dagger
            G5 = np.kron(np.eye(V), np.kron(g5, np.eye(nc)))
            lhs = G5 @ D @ G5
            g5h = np.allclose(lhs, D.conj().T, atol=1e-8)
            # paired-flavor positivity
            DdD = D.conj().T @ D
            eig = np.linalg.eigvalsh(DdD)
            pos = bool(np.all(eig > 1e-9))
            # det D real (consequence of g5h): det D should be real to tol
            sign_logdet = np.linalg.slogdet(D)
            det_real = abs(sign_logdet[0].imag) < 1e-8
            checks += 3
            fails += (0 if g5h else 1) + (0 if pos else 1) + (0 if det_real else 1)
            print(f"\n[{name} L={L} m={m:+.1f}]  dim={D.shape[0]}")
            print(f"  g5 D g5 == D^dagger : {'PASS' if g5h else 'FAIL'}")
            print(f"  det(D^d D)>0 (min eig={eig.min():.3e}) : "
                  f"{'PASS' if pos else 'FAIL'}")
            print(f"  det D real (|Im sign|={abs(sign_logdet[0].imag):.1e}) : "
                  f"{'PASS' if det_real else 'FAIL'}")

    # Negative control (structure-sensitivity): adding an imaginary-mass /
    # chemical-potential term  + i c I  must BREAK gamma5-hermiticity -
    # gamma5 (i c I) gamma5 = i c I  but  (i c I)^dagger = - i c I. This is
    # exactly the mu != 0 regime QMF4's honesty note flags as the sign problem;
    # a robust check that the g5h test is NOT vacuously true. On the SAME lattice
    # the un-perturbed D passes and the perturbed D_broken fails.
    print("\n[control] imaginary-mass term +icI must BREAK gamma5-hermiticity:")
    L = 2
    links = rand_u1_links(L, rng)
    D = wilson_dirac(L, 0.3, gammas, links, 1)
    V = L ** 4
    G5 = np.kron(np.eye(V), np.kron(g5, np.eye(1)))
    D_broken = D + 1j * 0.5 * np.eye(D.shape[0])
    good_g5h = np.allclose(G5 @ D @ G5, D.conj().T, atol=1e-8)
    broken_g5h = np.allclose(G5 @ D_broken @ G5, D_broken.conj().T, atol=1e-8)
    sensitive = good_g5h and (not broken_g5h)
    checks += 1
    fails += 0 if sensitive else 1
    print(f"  unperturbed D g5-hermitian: {good_g5h};  "
          f"+icI still g5-hermitian: {broken_g5h}  "
          f"{'PASS (sensitive)' if sensitive else 'FAIL (not sensitive)'}")

    print("\n" + "=" * 74)
    print(f"RESULT: {checks - fails}/{checks} checks passed")
    print("=" * 74)
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
